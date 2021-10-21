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
                    
                    CKService.currentModel.saveListUsersList(listID: ckList.id, key: "MyLists") { result in
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
        let ckList = listModelConverter.convertLocalListToCloud(withList: list)
        //passar só o id ao inves da list toda?
        
        ckService.deleteList(listID: ckList.id) { result in
            switch result {
                case .success(let result): print("deleteList() success \(result)")
                case .failure(let error): print("deleteList() error \(error)")
            }
        }
    }
    
    func updateListTitle(_ list: ListModel, _ newTitle: String) {
        let ckList = listModelConverter.convertLocalListToCloud(withList: list)
                
        ckService.updateListName(listName: newTitle, listID: ckList.id) { result in
            switch result {
                case .success(let result): print("updateListTitle() success \(result)")
                case .failure(let error): print("updateListTitle() error \(error)")
            }
        }
    }
    
    func updateCkListItems(updatedList: ListModel) {
        let ckList = listModelConverter.convertLocalListToCloud(withList: updatedList)
        
        let ckItemsStrings = ckList.itemsString
        
        ckService.updateListItems(listItems: ckItemsStrings, listID: ckList.id) { result in
            switch result {
                case .success(let result): print("updateListItems() success \(result)")
                case .failure(let error): print("updateListItems() error \(error.localizedDescription)")
            }
        }
    }
}
