//
//  DataIntegration.swift
//  Superlista
//
//  Created by Thaís Fernandes on 15/10/21.
//

import Foundation

class DataIntegration: ObservableObject {
    
    let listsViewModel = ListsViewModel.listsViewModel
    
    private let listModelConverter = ListModelConverter()
    
    private let itemModelConverter = ItemModelConverter()
    
    private let ckService = CKService.currentModel
    
    static var integration = DataIntegration()
    
    
    func createList(_ list: ListModel) {
        let ckList = listModelConverter.convertLocalListToCloud(withList: list)
        
        listsViewModel.addList(newItem: list)
        
        
    }
    
    func updateTitle() {
        
    }
    
    func updateListItems() {
        
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
