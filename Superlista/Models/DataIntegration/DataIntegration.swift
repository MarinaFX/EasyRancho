//
//  DataIntegration.swift
//  Superlista
//
//  Created by Thaís Fernandes on 15/10/21.
//

import Foundation
import Network
import CloudKit

class DataIntegration: ObservableObject {
    
    let listsViewModel = ListsViewModel.listsViewModel
    
    private let listModelConverter = ListModelConverter()
    
    private let itemModelConverter = ItemModelConverter()
    
    private let ckService = CKService.currentModel
    
    static var integration = DataIntegration()
    
    
    func createList(_ list: ListModel) {
        let ckList = listModelConverter.convertLocalListToCloud(withList: list)
        
        listsViewModel.addList(list)
                                
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
    
    func updateTitle(_ list: ListModel, _ newTitle: String) {
        let ckList = listModelConverter.convertLocalListToCloud(withList: list)
        
        listsViewModel.editListTitle(of: list, newTitle: newTitle)
        
        ckService.updateListName(listName: newTitle, listID: ckList.id) { result in
            switch result {
                case .success(let result): print("updateListTitle() success \(result)")
                case .failure(let error): print("updateListTitle() error \(error)")
            }
        }
    }
    
    func updateListItems(_ list: ListModel, items: [ItemModel]) {
        let ckList = listModelConverter.convertLocalListToCloud(withList: list)
        
        let ckItems = ckList.itemsString;
        
        items.forEach { item in
            listsViewModel.addItem(item, to: list)
        }
        
        ckService.updateListItems(listItems: ckItems, listID: ckList.id) { result in
            switch result {
                case .success(let result): print("updateListItems() success \(result)")
                case .failure(let error): print("updateListItems() error \(error)")
            }
        }
    }
    
    func deleteList() {
        
    }
    
    func deleteItem() {
        
    }
    
    func addItem() {
        
    }
    
    func toggleCompletion() {
        
    }
    
    func addComment() {
        
    }
    
    func toggleFavorite() {
        
    }
    
}
