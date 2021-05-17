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
    
    let products = ProductListViewModel().productsOrdered
    
    let itemsKey: String = "lists"
    
    init() {
        getItems()
    }
    
    func getItems() {
        guard
            let data = UserDefaults.standard.data(forKey: itemsKey),
            let savedItems = try? JSONDecoder().decode([ListModel].self, from: data)
        else { return }
        
        //if savedItems.isEmpty {
//            self.list = [
//                ListModel(title: "Churras", items: [
//                    "Carnes" : [
//                        ItemModel(product: products[43], comment: "Picanha"),
//                        ItemModel(product: products[44])
//                    ],
//                    "Bebidas" : [
//                        ItemModel(product: products[15], comment: "Coca"),
//                        ItemModel(product: products[10]),
//                        ItemModel(product: products[28]),
//                    ],
//                    "Temperos" : [
//                        ItemModel(product: products[303], comment: "Sal grosso"),
//                    ],
//                ], favorite: false),
//                ListModel(title: "Aniver", items: [
//                    "Congelados" : [
//                        ItemModel(product: products[61])
//                    ],
//                    "Bomboniere" : [
//                        ItemModel(product: products[32]),
//                        ItemModel(product: products[33]),
//                        ItemModel(product: products[34]),
//                        ItemModel(product: products[35]),
//                    ],
//                ], favorite: true),
//            ]
            
        //} else {
            self.list = savedItems
        //}
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
    
    func addItem(_ product: ProductModel, to listModel: ListModel) {
        print(listModel)
        if let index = list.firstIndex(where: { $0.id == listModel.id }) {
            list[index] = listModel.addItem(product)
        }
    }
    
    func addItems(_ products: [ProductModel], to listModel: ListModel) {
        if let index = list.firstIndex(where: { $0.id == listModel.id }) {
            list[index] = listModel.addItems(products)
        }
    }
    
    func removeItem(from row: IndexSet, of category: String, of listModel: ListModel) {
        if let index = list.firstIndex(where: { $0.id == listModel.id }) {
            list[index] = listModel.removeItem(from: row, of: category)
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
