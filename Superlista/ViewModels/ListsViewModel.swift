//
//  ListsViewModel.swift
//  Superlista
//
//  Created by Thaís Fernandes on 10/05/21.
//

import Foundation

class ListsViewModel: ObservableObject {
    @Published var list: [ListModel] = [] {
        didSet {
            saveItems()
        }
    }
    
    @Published var currentList: ListModel?
    
    @Published var currentCategory: CategoryModel?
    
    let products = ProductListViewModel().productsOrdered
    
    let itemsKey: String = "lists"
    
    static var listsViewModel = ListsViewModel()
    
    @Published var isGrid: Bool = false
    
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
    
    func addList(newItem: ListModel) {
        list.append(newItem)
    }
    
    /* CRUD Itens Lista */
    
//    func addItem(_ product: ProductModel, to listModel: ListModel) {
//        if let index = list.firstIndex(where: { $0.id == listModel.id }) {
//            list[index] = listModel.addItem(product)
//        }
//    }
    
    func addItem(_ item: ItemModel, to listModel: ListModel) {
        if let index = list.firstIndex(where: { $0.id == listModel.id }) {
            list[index] = listModel.addItem(item)
        }
    }
    
//    func addItems(_ products: [ProductModel], to listModel: ListModel) {
//        if let index = list.firstIndex(where: { $0.id == listModel.id }) {
//            list[index] = listModel.addItems(products)
//        }
//    }
    
    func removeItem(from row: IndexSet, of category: CategoryModel, of listModel: ListModel) {
        if let index = list.firstIndex(where: { $0.id == listModel.id }) {
            list[index] = listModel.removeItem(from: row, of: category)
        }
    }
    
    func removeItem(_ item: ItemModel, from listModel: ListModel) {
        if let index = list.firstIndex(where: { $0.id == listModel.id }) {
            list[index] = listModel.removeItem(item)
        }
    }
    
    func addComent(_ comment: String, to item: ItemModel, from listModel: ListModel) {
        if let index = list.firstIndex(where: { $0.id == listModel.id }) {
            list[index] = listModel.addComment(comment, to: item)
        }
    }
    
    func toggleCompletion(of item: ItemModel, from listModel: ListModel) {
        if let index = list.firstIndex(where: { $0.id == listModel.id }) {
            list[index] = listModel.toggleCompletion(of: item)
        }
    }
    
    
}
