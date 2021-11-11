import Foundation
import Network
import CloudKit

class CloudIntegration: ObservableObject {
    
    private let listModelConverter = ListModelConverter()
    
    private let itemModelConverter = ItemModelConverter()
    
    private let ckService = CKService.currentModel
    
    static var actions = CloudIntegration()
    
    func createList(_ list: ListModel) {
        let ckList = listModelConverter.convertLocalListToCloud(withList: list)
        
        CKService.currentModel.createList(listModel: ckList) { result in
            switch result {
                case .success:
                    
                    CKService.currentModel.saveListUsersList(listID: ckList.id, key: .MyLists) { result in
                        switch result {
                            case .success: return
                                                                
                            case .failure(let error): print(error)
                        }
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func deleteList(list: ListModel, userID: String) {
        if isOwner(of: list, userID: userID) {
            deleteListFromMyLists(list: list)
            deleteListFromAll(list: list)
            deleteListCollab(list: list)
        } else {
            deleteListFromSharedWithMe(list: list)
            removeCollab(of: list, ownerID: userID)
        }
    }
    
    func deleteListFromMyLists(list: ListModel) {
        CKService.currentModel.deleteUsersList(listId: CKRecord.ID(recordName: list.id), key: .MyLists) { result in
            switch result {
                case .success: print("delete from myList foi")

                case .failure(let error): print("delete from myList error \(error)")
            }
        }
    }
    
    func deleteListFromSharedWithMe(list: ListModel) {
        CKService.currentModel.deleteUsersList(listId: CKRecord.ID(recordName: list.id), key: .SharedWithMe) { result in
            switch result {
                case .success: print("delete from myList foi")

                case .failure(let error): print("delete from myList error \(error)")
            }
        }
    }
    
    func deleteListFromAll(list: ListModel) {
        CKService.currentModel.deleteList(listID: CKRecord.ID(recordName: list.id)) { result in
            switch result {
                case .success(let result): print("foi", result)

                case .failure(let error): print("nao foi", error)
            }
        }
    }
    
    func deleteListCollab(list: ListModel) {
        for collab in list.sharedWith ?? [] {
            CKService.currentModel.deleteListCollab(collabID: CKRecord.ID(recordName: collab.id), listID: CKRecord.ID(recordName: list.id)) { result in
                switch result {
                    case .success: print("delete from Collab foi")

                    case .failure(let error): print("delete from Collab error \(error)")
                }
            }
        }
    }
    
    func removeCollab(of list: ListModel, ownerID: String) {
        CKService.currentModel.deleteListCollab(collabID: CKRecord.ID(recordName: ownerID), listID: CKRecord.ID(recordName: list.id)) { result in }

        guard let index = list.sharedWith?.firstIndex(where: { ownerID == $0.id }) else { return }
        guard var sharedWith = list.sharedWith else { return }
        sharedWith.remove(at: index)
        
        var newCkCollabList: [CKOwnerModel] = []
        for shared in sharedWith {
            newCkCollabList.append(OwnerModelConverter().convertLocalToCKOwner(withUser: shared))
        }
        
        CKService.currentModel.updateListCollab(listID: CKRecord.ID(recordName: list.id), sharedWith: newCkCollabList) { result in }
    }
    
    func updateListTitle(_ list: ListModel, _ newTitle: String) {
        let ckList = listModelConverter.convertLocalListToCloud(withList: list)
                
        CKService.currentModel.updateListName(listName: newTitle, listID: ckList.id) { result in
            switch result {
                case .success(let result): print("updateListTitle() success \(result)")
                case .failure(let error): print("updateListTitle() error \(error)")
            }
        }
    }
    
    func updateCkListItems(updatedList: ListModel) {
        let ckList = listModelConverter.convertLocalListToCloud(withList: updatedList)
        
        let ckItemsStrings = ckList.itemsString
                
        CKService.currentModel.updateListItems(listItems: ckItemsStrings, listID: ckList.id) { result in
            switch result {
                case .success(let result): print("updateListItems() success \(result)")
                case .failure(let error): print("updateListItems() error \(error)")
            }
        }
    }
    
    func updateUserCustomProducts(withProduct customProduct: ProductModel) {
        let productModelConverter: ProductModelConverter = ProductModelConverter()
        var ckCustomProducts: [String] = CKService.currentModel.user?.customProductsString ?? []
        
        let customProductString: String = productModelConverter.convertLocalProductsToString(withProduct: customProduct)
        
        ckCustomProducts.append(customProductString)
        
        CKService.currentModel.updateCustomItems(customItems: ckCustomProducts) { result in
            switch result {
            case .success(let result):
                print("Updated custom products successfully. Result: \(result)")
            case .failure(let error):
                print("Error while trying to update custom products. Error: \(error)")
            }
        }
    }
    
    func addCollabList(of list: CKListModel) {
        CKService.currentModel.saveListUsersList(listID: list.id, key: .SharedWithMe) { result in }
        guard let ckUser = CKService.currentModel.user, let ckUserName = ckUser.name else { return }
        let user = CKOwnerModel(id: ckUser.id, name: ckUserName)
        var sharedWith = list.sharedWith
        sharedWith.append(user)
        CKService.currentModel.updateListCollab(listID: list.id, sharedWith: sharedWith) { result in }
    }
    
    // MARK: - Check if user is Owner
    func isOwner(of list: ListModel, userID: String) -> Bool {
        if userID == list.owner.id {
            return true
        } else {
            return false
        }
    }
}
