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
    
    func deleteList(_ list: ListModel) {
                
        deleteListFromMyLists(list: list)
        
        deleteListFromAll(list: list)
    }
    
    func deleteListFromMyLists(list: ListModel) {
        CKService.currentModel.deleteUsersList(listId: CKRecord.ID(recordName: list.id), key: .MyLists) { result in
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
}
