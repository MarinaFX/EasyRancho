//
//  ListsViewModel.swift
//  Superlista
//
//  Created by Thaís Fernandes on 10/05/21.
//

import Foundation

class ListsViewModel: ObservableObject {
    var list: [ListModel] = [] {
        didSet {
            saveItems()
            print(list, "localList")
        }
    }
    
    var currentList: ListModel?
    
    var currentCategory: CategoryModel?
    
    let products = ProductListViewModel().productsOrdered
    
    let itemsKey: String = "lists"
    
    static var listsViewModel = ListsViewModel()
    
    var isGrid: Bool = false
    
    init() {
        getItems()
    }
    
    func getItems() {
        guard
            let data = UserDefaults.standard.data(forKey: itemsKey),
            let savedItems = try? JSONDecoder().decode([ListModel].self, from: data)
        else { return }
        
        self.list = savedItems
    }
    
    func saveItems() {
        if let encodedData = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(encodedData, forKey: itemsKey)
        }
    }
    

    
    /* CRUD listas */
    func toggleListFavorite(of listModel: ListModel) {
        if let index = list.firstIndex(where: { $0.id == listModel.id }) {
            list[index] = listModel.toggleFavorite()
            currentList = list[index]
        }
    }
    
    func removeList(_ listModel: ListModel) {
        if let index = list.firstIndex(where: { $0.id == listModel.id }) {
            list.remove(at: index)
        }
    }
    
    func editListTitle(of listModel: ListModel, newTitle: String) {
        if let index = list.firstIndex(where: { $0.id == listModel.id }) {
            list[index] = listModel.editTitle(newTitle: newTitle)
        }
    }
    
    func addList(_ newList: ListModel) {
        list.append(newList)
    }
    
    func updateListId(_ newId: String, of listModel: ListModel) {
        if let index = list.firstIndex(where: { $0.id == listModel.id }) {
            list[index] = listModel.setId(newId)
        }
    }
    
    /* CRUD Itens Lista */
    
    func addItem(_ item: ItemModel, to listModel: ListModel) -> ListModel? {
        if let index = list.firstIndex(where: { $0.id == listModel.id }) {
            list[index] = listModel.addItem(item)
            return list[index]
        }
        return nil
    }
    
    func removeItem(from row: IndexSet, of category: CategoryModel, of listModel: ListModel) -> ListModel? {
        if let index = list.firstIndex(where: { $0.id == listModel.id }) {
            list[index] = listModel.removeItem(from: row, of: category)
            return list[index]
        }
        return nil
    }
    
    func removeItem(_ item: ItemModel, from listModel: ListModel) -> ListModel? {
        if let index = list.firstIndex(where: { $0.id == listModel.id }) {
            list[index] = listModel.removeItem(item)
            return list[index]
        }
        return nil
    }
    
    func addComent(_ comment: String, to item: ItemModel, from listModel: ListModel) -> ListModel? {
        if let index = list.firstIndex(where: { $0.id == listModel.id }) {
            list[index] = listModel.addComment(comment, to: item)
            return list[index]
        }
        return nil
    }
    
    func toggleCompletion(of item: ItemModel, from listModel: ListModel) -> ListModel? {
        if let index = list.firstIndex(where: { $0.id == listModel.id }) {
            list[index] = listModel.toggleCompletion(of: item)
            return list[index]
        }
        return nil
    }
    
    
}
