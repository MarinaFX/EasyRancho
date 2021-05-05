//
//  ListViewModel.swift
//  Superlista
//
//  Created by Thaís Fernandes on 05/05/21.
//

import Foundation

class ListViewModel: ObservableObject {
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
        guard
            let data = UserDefaults.standard.data(forKey: itemsKey),
            let savedItems = try? JSONDecoder().decode([ItemModel].self, from: data)
        else { return }
        
        self.list = savedItems
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

