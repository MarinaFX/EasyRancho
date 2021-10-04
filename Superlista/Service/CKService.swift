//
//  CKService.swift
//  Superlista
//
//  Created by Gabriela Zorzo on 04/10/21.
//

import Foundation
import CloudKit

class CKServices: ObservableObject {
    
    enum UserStatus {
        case available, noAccount, couldNotDetermine, restricted, none
    }
    
    // MARK: - iCloud Info
    let container: CKContainer
    let publicDB: CKDatabase // Lists
    let privateDB: CKDatabase // Users
    
    // MARK: - Properties
    private(set) var user: UserModel?
    
    static var currentModel = CKServices()
    
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
    
    }
    
    // MARK: - Verify Account
    private func verifyAccount(completion: @escaping (UserStatus) -> Void) {
        container.accountStatus { status, error in
            if let _ = error {
                completion(.none)
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
    private func getUser(completion: @escaping (Result<UserModel,CKError>) -> Void ) {
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
            let user = UserModel(record: record)
            completion(.success(user))
            dispatchSemaphore.signal()
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
        let record = CKRecord(recordType: "Lists")
        record.setValue(listModel.name, forKey: "ListName")
        record.setValue(listModel.itemsString, forKey: "Items")
        
        publicDB.save(record) { savedRecord, error in
            if error == nil {
                completion(.success(savedRecord!.recordID))
    
            } else {
                completion(.failure(error as! CKError))
            }
        }
    }
    
    // MARK: - Save List in Users Lists
    func saveListUsersList(listID: CKRecord.ID, completion: @escaping (Result<CKRecord.ID,CKError>) -> Void) {
        var usersLists = user!.myLists
        
        usersLists?.append(CKRecord.Reference(recordID: listID, action: CKRecord.ReferenceAction.none))
        
        guard let userID = user?.id else {
            completion(.failure(CKError.init(CKError.operationCancelled)))
            return
        }
        
        publicDB.fetch(withRecordID: userID) { record, error in
            if error == nil {
                record!.setValue(usersLists, forKey: "MyLists")
                
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
    
}
