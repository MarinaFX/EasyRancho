import Foundation
import CloudKit
import SwiftUI
import Combine

class CKService: ObservableObject {
    
    enum UserStatus {
        case available, noAccount, couldNotDetermine, restricted, none
    }
    
    // MARK: - iCloud Info
    let container: CKContainer
    let publicDB: CKDatabase // Lists
    let privateDB: CKDatabase // Users
    
    // MARK: - Properties
    var user: CKUserModel? {
        didSet {
            userSubject.value = user 
        }
    }
    
    let userSubject: CurrentValueSubject<CKUserModel?, Never> = .init(nil)
    
    static var currentModel = CKService()
    
    private init() {
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
    }
    
    // MARK: - Refresh
    @objc func refresh(_ completion: @escaping (Error?) -> Void) {
        var userStatus: UserStatus = .none
        
        let dispatchSemaphore = DispatchSemaphore(value: 1)
        dispatchSemaphore.wait()
        
        self.verifyAccount { status in
            userStatus = status
            dispatchSemaphore.signal()
        }
        
        dispatchSemaphore.wait()
        
        if userStatus == .available {
            getUser { result in
                switch result {
                case .success(let user):
                    self.user = user
                case .failure(let error):
                    completion(error)
                }
                dispatchSemaphore.signal()
            }
        }
        else {
            dispatchSemaphore.signal()
        }
        
    }
    
    // MARK: - Refresh Return User
    func refreshUser(_ completion: @escaping (Result<CKUserModel,CKError>) -> Void) {
        var userStatus: UserStatus = .none
        
        let dispatchSemaphore = DispatchSemaphore(value: 1)
        dispatchSemaphore.wait()
        
        self.verifyAccount { status in
            userStatus = status
            dispatchSemaphore.signal()
        }
        
        dispatchSemaphore.wait()
        
        if userStatus == .available {
            getUser { result in
                switch result {
                case .success(let user):
                    completion(.success(user))
                case .failure(let error):
                    completion(.failure(error))
                }
                dispatchSemaphore.signal()
            }
        }
        else {
            dispatchSemaphore.signal()
        }
        
    }
    
    // MARK: - Verify Account
    private func verifyAccount(completion: @escaping (UserStatus) -> Void) {
        container.accountStatus { status, error in
            if let _ = error {
                let userStatus = UserStatus.none
                completion(userStatus)
            } else {
                let userStatus = self.parseCKAccountStatus(status: status)
                completion(userStatus)
            }
        }
    }
    
    // MARK: - Account Status
    private func parseCKAccountStatus(status: CKAccountStatus) -> UserStatus {
        switch status {
        case .available:
            return .available
        case .noAccount:
            return .noAccount
        case .couldNotDetermine:
            return .couldNotDetermine
        case .restricted:
            return .restricted
        default:
            return .none
        }
    }
    
    // MARK: - Get User
    func getUser(completion: @escaping (Result<CKUserModel,CKError>) -> Void ) {
        let dispatchSemaphore = DispatchSemaphore(value: 1)
        dispatchSemaphore.wait()
        
        var recordID: CKRecord.ID?
        
        self.container.fetchUserRecordID { cloudRecordID, error in
            guard let localRecordID = cloudRecordID else {
                let ckError = error as? CKError
                completion(.failure(ckError ?? CKError(.internalError)))
                dispatchSemaphore.signal()
                return
            }
            recordID = localRecordID
            dispatchSemaphore.signal()
        }
        
        dispatchSemaphore.wait()
        
        guard let recordID = recordID else {
            completion(.failure(CKError(.internalError)))
            dispatchSemaphore.signal()
            return
        }
        
        self.publicDB.fetch(withRecordID: recordID) { record, error in
            guard let record = record, error == nil else {
                let ckerror = error as? CKError
                completion(.failure(ckerror ?? CKError(.internalError)))
                dispatchSemaphore.signal()
                return
            }
            
            let _ = CKUserModel(record: record) { user in
                completion(.success(user))
                dispatchSemaphore.signal()
            }
            
        }
    }
    
//    // MARK: - Get another user name
    func getAnotherUser(userID: CKRecord.ID, completion: @escaping (Result<CKOwnerModel,CKError>) -> Void) {
        publicDB.fetch(withRecordID: userID) { record, error in
            if error == nil {
                let user = CKOwnerModel(record: record!)
                completion(.success(user))
                return
            } else {
                completion(.failure(error as! CKError))
                return
            }
        }
    }
    
    // MARK: - Update User Name
    func updateUserName(name: String, completion: @escaping (Result<CKRecord.ID,CKError>) -> Void) {
        getUser { result in
            switch result {
            case .success(let user):
                self.publicDB.fetch(withRecordID: user.id) { record, error in
                    if error == nil {
                        record!.setValue(name, forKey: "UserName")
                        
                        self.publicDB.save(record!) { user, error in
                            if error == nil {
                                self.refresh { error in
                                    completion(.success(record!.recordID))
                                }
                            } else {
                                completion(.failure(error as! CKError))
                            }
                        }
                    } else {
                        completion(.failure(error as! CKError))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Update User Image
    func updateUserImage(image: UIImage, completion: @escaping (Result<CKRecord.ID,CKError>) -> Void) {
        guard let user = user else {
            return
            
        }
        self.publicDB.fetch(withRecordID: user.id) { record, error in
            if error == nil {
                record!.setValue(ImageToCKAsset(uiImage: image), forKey: "Image")
                self.publicDB.save(record!) { user, error in
                    if error == nil {
                        self.refresh { error in
                            completion(.success(user!.recordID))
                        }
                    } else {
                        completion(.failure(error as! CKError))
                    }
                }
            } else {
                completion(.failure(error as! CKError))
            }
        }
    }
    
    // MARK: - Update User Image and Name
    func updateUserImageAndName(image: UIImage, name: String, completion: @escaping (Result<CKRecord.ID,CKError>) -> Void) {
        guard let user = user else {
            return
        }
        self.publicDB.fetch(withRecordID: user.id) { record, error in
            if error == nil {
                record!.setValue(ImageToCKAsset(uiImage: image), forKey: "Image")
                record!.setValue(name, forKey: "UserName")
                self.publicDB.save(record!) { user, error in
                    if error == nil {
                        self.refresh { error in
                            completion(.success(user!.recordID))
                        }
                    } else {
                        completion(.failure(error as! CKError))
                    }
                }
            } else {
                completion(.failure(error as! CKError))
            }
        }
    }
    
    // MARK: - Remove User's List
    func deleteUsersList(listId: CKRecord.ID, key: UsersList, completion: @escaping (Result<CKRecord.ID,CKError>) -> Void) {
        var usersLists: [CKRecord.Reference] = []
        
        if key == UsersList.MyLists {
            usersLists = user!.myListsRef!
            
        } else if key == UsersList.SharedWithMe {
            usersLists = user!.sharedWithMeRef!
        }
        
        if let listToDeleteIndex = usersLists.firstIndex(where: { $0.recordID.recordName == listId.recordName }) {
            usersLists.remove(at: listToDeleteIndex)
        }
        
        guard let userID = user?.id else {
            completion(.failure(CKError.init(CKError.operationCancelled)))
            return
        }
        
        publicDB.fetch(withRecordID: userID) { record, error in
            
            if error == nil {
                
                record!.setValue(usersLists, forKey: key.rawValue)
                
                self.publicDB.save(record!) { savedUserList, error in
                    if error == nil {
                        self.refresh { error in
                            completion(.success(record!.recordID))
                        }
                    } else {
                        completion(.failure(error as! CKError))
                    }
                }
            } else {
                completion(.failure(error as! CKError))
            }
        }
    }
    
    // MARK: - Add User's List
    func addUsersList(list: CKListModel, key: UsersList, completion: @escaping (Result<CKRecord.ID,CKError>) -> Void) {
        var usersLists: [CKRecord.Reference] = []
        
        let listToAddRef = ListModelConverter().convertCloudListToReference(withList: list)
        
        if key == UsersList.MyLists {
            usersLists = user!.myListsRef!
            
        } else if key == UsersList.SharedWithMe {
            usersLists = user!.sharedWithMeRef!
            
        }
        
        usersLists.append(listToAddRef)
        
        guard let userID = user?.id else {
            completion(.failure(CKError.init(CKError.operationCancelled)))
            return
        }
        
        publicDB.fetch(withRecordID: userID) { record, error in
            if error == nil {
                record!.setValue(usersLists, forKey: key.rawValue)
                
                self.publicDB.save(record!) { savedUserList, error in
                    if error == nil {
                        self.refresh { error in
                            completion(.success(record!.recordID))
                        }
                    } else {
                        completion(.failure(error as! CKError))
                    }
                }
            } else {
                completion(.failure(error as! CKError))
            }
        }
    }
    
    // MARK: - Upload User's Lists
    func uploadUsersLists(completion: @escaping (Result<CKRecord.ID,CKError>) -> Void) {
        guard let userID = user?.id else {
            completion(.failure(CKError.init(CKError.operationCancelled)))
            return
        }
        
        print("upload users list")
        
        let sharedWithMe = user?.sharedWithMeRef ?? []
        let myLists = user?.myListsRef ?? []
        
        publicDB.fetch(withRecordID: userID) { record, error in
            if error == nil {
                record!.setValue(sharedWithMe, forKey: UsersList.SharedWithMe.rawValue)
                record!.setValue(myLists, forKey: UsersList.MyLists.rawValue)
                
                self.publicDB.save(record!) { savedUserList, error in
                    if error == nil {
                        self.refresh { error in
                            completion(.success(record!.recordID))
                        }
                    } else {
                        completion(.failure(error as! CKError))
                    }
                }
            } else {
                completion(.failure(error as! CKError))
            }
        }
    }
    
    // MARK: - Update Custom Items
    func updateCustomItems(customItems: [String], completion: @escaping (Result<CKRecord.ID,CKError>) -> Void) {
        getUser { result in
            switch result {
            case .success(let user):
                self.publicDB.fetch(withRecordID: user.id) { record, error in
                    if error == nil {
                        record!.setValue(customItems, forKey: "CustomItems")
                        
                        self.publicDB.save(record!) { user, error in
                            if error == nil {
                                self.refresh { error in
                                    completion(.success(record!.recordID))
                                }
                            } else {
                                completion(.failure(error as! CKError))
                            }
                        }
                    } else {
                        completion(.failure(error as! CKError))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Get List
    func getList(listID: CKRecord.ID, completion: @escaping (Result<CKListModel,CKError>) -> Void) {
        let dispatchSemaphore = DispatchSemaphore(value: 1)
        dispatchSemaphore.wait()
        
        let listIDRecord = listID
        
        publicDB.fetch(withRecordID: listIDRecord) { record, error in
            if error == nil {
                completion(.success(CKListModel(record: record!)))
                dispatchSemaphore.signal()
                return
            } else {
                completion(.failure(error as! CKError))
                dispatchSemaphore.signal()
                return
            }
        }
    }
    
    // MARK: - Create List
    func createList(listModel: CKListModel, completion: @escaping (Result<CKRecord.ID,CKError>) -> Void) {
        let record = CKRecord(recordType: "Lists", recordID: listModel.id)
        record.setValue(listModel.name, forKey: "ListName")
        record.setValue(listModel.itemsString, forKey: "Items")
        record.setValue(CKRecord.Reference(recordID: user!.id, action: .none), forKey: "Owner")
        
        publicDB.save(record) { savedRecord, error in
            if error == nil {
                completion(.success(savedRecord!.recordID))
                
            } else {
                completion(.failure(error as! CKError))
            }
        }
    }
    
    // MARK: - Save List in Users Lists
    func saveListUsersList(listID: CKRecord.ID, key: UsersList, completion: @escaping (Result<CKRecord.ID,CKError>) -> Void) {
        
        var usersLists: [CKRecord.Reference] = []
        
        if key == UsersList.MyLists {
            usersLists = user!.myListsRef!
            
        } else if key == UsersList.SharedWithMe {
            usersLists = user!.sharedWithMeRef!
            
        }
        
        usersLists.append(CKRecord.Reference(recordID: listID, action: CKRecord.ReferenceAction.none))
        
        guard let userID = user?.id else {
            completion(.failure(CKError.init(CKError.operationCancelled)))
            return
        }
        
        publicDB.fetch(withRecordID: userID) { record, error in
            if error == nil {
                record!.setValue(usersLists, forKey: key.rawValue)
                
                self.publicDB.save(record!) { savedUserList, error in
                    if error == nil {
                        self.refresh { error in
                            completion(.success(record!.recordID))
                        }
                    } else {
                        completion(.failure(error as! CKError))
                    }
                }
            } else {
                completion(.failure(error as! CKError))
            }
        }
    }
    
    
    // MARK: - Update List
    func updateListItems(listItems: [String], listID: CKRecord.ID, completion: @escaping (Result<CKRecord.ID,CKError>) -> Void) {
        publicDB.fetch(withRecordID: listID) { record, error in
            if error == nil {
                record!.setValue(listItems, forKey: "Items")
                
                self.publicDB.save(record!) { savedUserList, error in
                    if error == nil {
                        self.refresh { error in
                            completion(.success(record!.recordID))
                        }
                    } else {
                        completion(.failure(error as! CKError))
                    }
                }
            } else {
                completion(.failure(error as! CKError))
            }
        }
    }
    
    func updateListName(listName: String, listID: CKRecord.ID, completion: @escaping (Result<CKRecord.ID,CKError>) -> Void) {
        publicDB.fetch(withRecordID: listID) { record, error in
            if error == nil {
                record!.setValue(listName, forKey: "ListName")
                
                self.publicDB.save(record!) { savedUserList, error in
                    if error == nil {
                        self.refresh { error in
                            completion(.success(record!.recordID))
                        }
                    } else {
                        completion(.failure(error as! CKError))
                    }
                }
            } else {
                completion(.failure(error as! CKError))
            }
        }
    }
    
    func updateListCollab(listID: CKRecord.ID, sharedWith: [CKOwnerModel], completion: @escaping (Result<CKRecord.ID,CKError>) -> Void) {
        var sharedWithRef: [CKRecord.Reference] = []
        for shared in sharedWith {
            sharedWithRef.append(CKRecord.Reference(recordID: shared.id, action: .none))
        }
        
        publicDB.fetch(withRecordID: listID) { record, error in
            if error == nil {
                record!.setValue(sharedWithRef, forKey: "SharedWith")
                
                self.publicDB.save(record!) { savedUserList, error in
                    if error == nil {
                        self.refresh { error in
                            completion(.success(record!.recordID))
                        }
                    } else {
                        completion(.failure(error as! CKError))
                    }
                }
            } else {
                completion(.failure(error as! CKError))
            }
        }
    }
    
    // MARK: - Delete List
    func deleteList(listID: CKRecord.ID, completion: @escaping (Result<CKRecord.ID,CKError>) -> Void) {
        publicDB.delete(withRecordID: listID) { deleteRecordID, error in
            if error == nil {
                DispatchQueue.main.async {
                    self.refresh { error in
                        completion(.success(deleteRecordID!))
                    }
                }
            } else {
                completion(.failure(error as! CKError))
            }
        }
    }
    
    func deleteListCollab(collabID: CKRecord.ID, listID: CKRecord.ID, completion: @escaping (Result<CKRecord.ID,CKError>) -> Void) {
        
        publicDB.fetch(withRecordID: collabID) { record, error in
            if error == nil {
                var usersLists = record!["SharedWithMe"] as? [CKRecord.Reference] ?? []
                
                if let listToDeleteIndex = usersLists.firstIndex(where: { $0.recordID.recordName == listID.recordName }) {
                    usersLists.remove(at: listToDeleteIndex)
                }
                
                record!.setValue(usersLists, forKey: UsersList.SharedWithMe.rawValue)
                
                self.publicDB.save(record!) { savedUserList, error in
                    if error == nil {
                        self.refresh { error in
                            completion(.success(record!.recordID))
                        }
                    } else {
                        completion(.failure(error as! CKError))
                    }
                }
            } else {
                completion(.failure(error as! CKError))
            }
        }
    }
}
