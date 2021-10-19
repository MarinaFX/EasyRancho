//
//  ListsViewModel.swift
//  Superlista
//
//  Created by Thaís Fernandes on 10/05/21.
//

import Foundation
import CloudKit

class ListsViewModel: ObservableObject {
    @Published var list: [ListModel] = [] {
        didSet {
            saveItems()
            print(list, "listsViewModel list")
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
    
    // MARK: - CRUD lists
    func toggleListFavorite(of listModel: ListModel) {
        if let index = list.firstIndex(where: { $0.id == listModel.id }) {
            let newListState = listModel.toggleFavorite()
            
            list[index] = newListState
            
            CloudIntegration.actions.updateCkListItems(updatedList: newListState)
        }
    }
    
    func removeList(_ listModel: ListModel) {
        if let index = list.firstIndex(where: { $0.id == listModel.id }) {
            list.remove(at: index)
            
            CloudIntegration.actions.deleteList(listModel)
        }
    }
    
    func editListTitle(of listModel: ListModel, newTitle: String) {
        if let index = list.firstIndex(where: { $0.id == listModel.id }) {
            list[index] = listModel.editTitle(newTitle: newTitle)
            
            CloudIntegration.actions.updateListTitle(listModel, newTitle)
        }
    }
    
    func addList(_ newList: ListModel) {
        list.append(newList)
        
        CloudIntegration.actions.createList(newList)
    }
    
    // MARK: - CRUD List Items
    func addItem(_ item: ItemModel, to listModel: ListModel) {
        if let index = list.firstIndex(where: { $0.id == listModel.id }) {
            let listWithNewItem = listModel.addItem(item)
            
            list[index] = listWithNewItem
            
            CloudIntegration.actions.updateCkListItems(updatedList: listWithNewItem)
        }
    }
    
    func removeItem(from row: IndexSet, of category: CategoryModel, of listModel: ListModel) {
        if let index = list.firstIndex(where: { $0.id == listModel.id }) {
            let listWithoutItem = listModel.removeItem(from: row, of: category)
            
            list[index] = listWithoutItem
            
            CloudIntegration.actions.updateCkListItems(updatedList: listWithoutItem)
        }
    }
    
    func removeItem(_ item: ItemModel, from listModel: ListModel) {
        if let index = list.firstIndex(where: { $0.id == listModel.id }) {
            let listWithoutItem = listModel.removeItem(item)

            list[index] = listWithoutItem
            
            CloudIntegration.actions.updateCkListItems(updatedList: listWithoutItem)
        }
    }
    
    func addComent(_ comment: String, to item: ItemModel, from listModel: ListModel) {
        if let index = list.firstIndex(where: { $0.id == listModel.id }) {
            let listWithNewItemComment = listModel.addComment(comment, to: item)
            
            list[index] = listWithNewItemComment
            
            CloudIntegration.actions.updateCkListItems(updatedList: listWithNewItemComment)
        }
    }
    
    func toggleCompletion(of item: ItemModel, from listModel: ListModel) {
        if let index = list.firstIndex(where: { $0.id == listModel.id }) {
            let listWithItemNewState = listModel.toggleCompletion(of: item)
            
            list[index] = listWithItemNewState
            
            CloudIntegration.actions.updateCkListItems(updatedList: listWithItemNewState)
        }
    }
}
