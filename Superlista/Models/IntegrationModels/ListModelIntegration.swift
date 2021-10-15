//
//  Integration.swift
//  Superlista
//
//  Created by Thaís Fernandes on 14/10/21.
//

import Foundation

//crud = create, retrieve, update and delete
class DataModelIntegration: ObservableObject {
    let listsViewModel = ListsViewModel.listsViewModel

    private let listModelConverter = ListModelConverter()
    
    private let itemModelConverter = ItemModelConverter()
        
    private let ckService = CKService.currentModel
    
    static var integration = DataModelIntegration()

    
    func createList(_ list: ListModel) {
        let ckList = listModelConverter.convertLocalListToCloud(withList: list)

        listsViewModel.addList(list)

        //if online {
        ckService.createList(listModel: ckList) { result in
            switch result {
                case .success(let result): print("createList() success \(result)")
                
                case .failure(let error): print("createList() error \(error)")
            }
        }
        //}
    }
    
    func updateListTitle(_ list: ListModel, _ newTitle: String) {
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
        
        let ckItems = items.map({ "\($0.product.name);0;\(String(describing: $0.comment));\($0.isCompleted)" })
        //criar na classe ItemModelConverter?
        
        items.forEach { item in
            let _ = listsViewModel.addItem(item, to: list)
        }
        
        ckService.updateListItems(listItems: ckItems, listID: ckList.id) { result in
            switch result {
                case .success(let result): print("updateListItems() success \(result)")
                case .failure(let error): print("updateListItems() error \(error)")
            }
        }
        
    }
    
    func deleteList(_ list: ListModel) {
        let ckList = listModelConverter.convertLocalListToCloud(withList: list)
        
        listsViewModel.removeList(list)
        
        ckService.deleteList(listID: ckList.id) { result in
            switch result {
                case .success(let result): print("deleteList() success \(result)")
                case .failure(let error): print("deleteList() error \(error)")
            }
        }
    }
    
    func removeItemFromList(from row: IndexSet, of category: CategoryModel, of list: ListModel) {
        guard let listWithoutItem = listsViewModel.removeItem(from: row, of: category, of: list) else {
            return
        }
        
        updateCkListItems(updatedList: listWithoutItem)
    }
    
    func removeItem(_ item: ItemModel, from list: ListModel) {
        guard let listWithoutItem = listsViewModel.removeItem(item, from: list) else {
            return
        }
        
        updateCkListItems(updatedList: listWithoutItem)
    }
    
    func addItem(_ item: ItemModel, to list: ListModel) {
        guard let listWithNewItem = listsViewModel.addItem(item, to: list) else {
            return
        }
        
        updateCkListItems(updatedList: listWithNewItem)
    }
    
    func toggleCompletion(of item: ItemModel, from list: ListModel) {
        guard let updatedList = listsViewModel.toggleCompletion(of: item, from: list) else {
            return
        }
        
        updateCkListItems(updatedList: updatedList)
    }
    
    func addComent(_ comment: String, to item: ItemModel, from list: ListModel) {
        guard let updatedList = listsViewModel.addComent(comment, to: item, from: list) else {
            return
        }
        
        updateCkListItems(updatedList: updatedList)
    }
    
    func updateCkListItems(updatedList: ListModel) {
        let ckList = listModelConverter.convertLocalListToCloud(withList: updatedList)
        
        let ckItemsStrings = itemModelConverter.convertLocalItemsToCloudItems(withItemsList: updatedList.items).map({ $0.parseToCSV() })
        
        print(ckItemsStrings, "ckItemsStrings")
        
        ckService.updateListItems(listItems: ckItemsStrings, listID: ckList.id) { result in
            switch result {
                case .success(let result): print("updateListItems() success \(result)")
                case .failure(let error): print("updateListItems() error \(error.localizedDescription)")
            }
        }
    }
}
