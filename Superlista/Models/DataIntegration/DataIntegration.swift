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
    
    var lists: [ListModel] {
        return listsViewModel.list
    }
    
    var currentList: ListModel? {
        return listsViewModel.currentList
    }
    
    func getLists() -> [ListModel] {
        return listsViewModel.list
    }
    
    func setCurrentList(list: ListModel) {
        listsViewModel.currentList = list
    }
    
    func createList(_ list: ListModel) {
        
        listsViewModel.addList(list)
        
//        let ckList = listModelConverter.convertLocalListToCloud(withList: list)

//        print(CKService.currentModel.user?.myLists)
                                
//        CKService.currentModel.createList(listModel: ckList) { result in
//            switch result {
//                case .success:
//
//                    CKService.currentModel.saveListUsersList(listID: ckList.id, key: "MyLists") { result in
//                        switch result {
//                            case .success(let result):
//
//                                print("foi", result)
//
//                            case .failure(let error):
//
//                                print("nao foi", error)
//
//                        }
//                    }
//                case .failure(let error):
//                    print("createList() error \(error)")
//            }
//        }
    }
    
    func updateTitle(_ list: ListModel, _ newTitle: String) {
//        let ckList = listModelConverter.convertLocalListToCloud(withList: list)
        
        listsViewModel.editListTitle(of: list, newTitle: newTitle)
        
//        ckService.updateListName(listName: newTitle, listID: ckList.id) { result in
//            switch result {
//                case .success(let result): print("updateListTitle() success \(result)")
//                case .failure(let error): print("updateListTitle() error \(error)")
//            }
//        }
    }
    
    func updateListItems(_ list: ListModel, items: [ItemModel]) {
//        let ckList = listModelConverter.convertLocalListToCloud(withList: list)
//
//        let ckItems = ckList.itemsString;
//
        items.forEach { item in
            listsViewModel.addItem(item, to: list)
        }
//
//        ckService.updateListItems(listItems: ckItems, listID: ckList.id) { result in
//            switch result {
//                case .success(let result): print("updateListItems() success \(result)")
//                case .failure(let error): print("updateListItems() error \(error)")
//            }
//        }
    }
    
    func deleteList(_ list: ListModel) {
        listsViewModel.removeList(list)
    }
    
    func deleteItem(_ item: ItemModel, from list: ListModel) {
        listsViewModel.removeItem(item, from: list)
    }
    
    func deleteItem(from row: IndexSet, of category: CategoryModel, from list: ListModel) {
        listsViewModel.removeItem(from: row, of: category, of: list)
    }
    
    func addItem(_ item: ItemModel, to list: ListModel) {
        listsViewModel.addItem(item, to: list)
    }
    
    func toggleCompletion(of item: ItemModel, from list: ListModel) {
        listsViewModel.toggleCompletion(of: item, from: list)
    }
    
    func addComment(_ comment: String, to item: ItemModel, from list: ListModel) {
        listsViewModel.addComent(comment, to: item, from: list)
    }
    
    func toggleFavorite(of list: ListModel) {
        listsViewModel.toggleListFavorite(of: list)
    }
    
}
