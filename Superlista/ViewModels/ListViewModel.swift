//
//  ListViewModel.swift
//  Superlista
//
//  Created by Thaís Fernandes on 05/05/21.
//

import Foundation

class ListViewModel: ObservableObject {
    let products = ProductListViewModel().products

    @Published var list: [ItemModel] = [] {
        didSet {
            saveItems()
        }
    }
    
    let itemsKey: String = "list"
    
    init() {
        getItems()
    }
    
    func getItems() {
//        guard
//            let data = UserDefaults.standard.data(forKey: itemsKey),
//            let savedItems = try? JSONDecoder().decode([ItemModel].self, from: data)
//        else { return }
        
        //self.list = savedItems
        self.list = [
            ItemModel(product: products[0]),
            ItemModel(product: products[10]),
            ItemModel(product: products[22]),
            ItemModel(product: products[23]),
            ItemModel(product: products[34]),
            ItemModel(product: products[200]),
            ItemModel(product: products[100]),
            ItemModel(product: products[110]),
            ItemModel(product: products[90]),
            ItemModel(product: products[91]),
            ItemModel(product: products[92]),
            ItemModel(product: products[70])
        ]
    }
    
    func deleteItem(indexSet: IndexSet) {
        list.remove(atOffsets: indexSet)
    }
    
    func addItem(product: ProductModel) {
        let newItem = ItemModel(product: product)
        list.append(newItem)
    }
    
    func updateItemCompletion(item: ItemModel) {
        if let index = list.firstIndex(where: { $0.id == item.id }) {
            list[index] = item.toggleCompletion()
        }
    }

    func updateItemComment(item: ItemModel, comment: String) {
        if let index = list.firstIndex(where: { $0.id == item.id }) {
            list[index] = item.editComment(newComment: comment)
        }
    }
    
    
    func saveItems() {
        if let encodedData = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(encodedData, forKey: itemsKey)
        }
    }
}

