//
//  DataIntegration.swift
//  Superlista
//
//  Created by Thaís Fernandes on 15/10/21.
//

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
                            case .success(let result):
                                
                                print("foi", result)
                                
                            case .failure(let error):
                                
                                print("nao foi", error)
                                
                        }
                    }
                case .failure(let error):
                    print("createList() error \(error)")
            }
        }
    }
    
    func deleteList(_ list: ListModel) {
        CKService.currentModel.deleteUsersList(listId: CKRecord.ID(recordName: list.id), key: .MyLists) { result in
            switch result {
                case .success: print("deleteList() foi")
 
                case .failure(let error): print("deleteList() error \(error)")
            }
        }
        
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
    
    func toggleFavorite(of list: ListModel) {
        let ckList = listModelConverter.convertLocalListToCloud(withList: list)
    
        if list.favorite {
            CKService.currentModel.addUsersList(list: ckList, key: .FavoriteLists) { result in
                switch result {
                    case .success(let result): print("toggleFavorite() success \(result)")
                    case .failure(let error): print("toggleFavorite() error \(error)")
                }
            }
            
        } else {
            CKService.currentModel.deleteUsersList(listId: ckList.id, key: .FavoriteLists) { result in
                switch result {
                    case .success(let result): print("toggleFavorite() success \(result)")
                    case .failure(let error): print("toggleFavorite() error \(error)")
                }
            }
        }
    }
    
    
    func updateCkListItems(updatedList: ListModel) {
        let ckList = listModelConverter.convertLocalListToCloud(withList: updatedList)
        
        let ckItemsStrings = ckList.itemsString
                
        CKService.currentModel.updateListItems(listItems: ckItemsStrings, listID: ckList.id) { result in
            switch result {
                case .success(let result): print("updateListItems() success \(result)")
                case .failure(let error): print("updateListItems() error \(error.localizedDescription)")
            }
        }
    }
}
