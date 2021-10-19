//
//  ListModel.swift
//  Superlista
//
//  Created by Thaís Fernandes on 10/05/21.
//

import Foundation
import CloudKit

struct ListModel: Identifiable, Decodable, Encodable {
    var id: String
    var title: String
    var items: [CategoryModel: [ItemModel]]
    var favorite: Bool
    
    var owner: UserModel
    var sharedWith: [UserModel]?
    
    init(title: String, items: [CategoryModel: [ItemModel]] = [:], favorite: Bool = false, owner: UserModel, sharedWith: [UserModel] = []) {
        let recordID = CKRecord.ID()
        
        self.id = recordID.recordName
        self.title = title
        self.items = items
        self.favorite = favorite
        self.owner = owner
    }
    
    init(id: String, title: String, items: [CategoryModel: [ItemModel]] = [:], favorite: Bool = false, owner: UserModel, sharedWith: [UserModel] = []) {
        self.id = id
        self.title = title
        self.items = items
        self.favorite = favorite
        self.owner = owner
    }
    
    func toggleFavorite() -> ListModel {
        return ListModel(id: id, title: title, items: items, favorite: !favorite, owner: owner)
    }
    
    func editTitle(newTitle: String) -> ListModel {
        return ListModel(id: id, title: newTitle, items: items, favorite: favorite, owner: owner)
    }
    
    func addItem(_ item: ItemModel) -> ListModel {
        var newItemsList = items
                
        if let category = newItemsList.first(where: { $0.key.title == item.product.category })?.key {
            newItemsList[category]?.append(item)
        } else {
            newItemsList[CategoryModel(title: item.product.category)] = [item]
        }
                
        return ListModel(id: id, title: title, items: newItemsList, favorite: favorite, owner: owner)
    }
    
    func removeItem(from row: IndexSet, of category: CategoryModel) -> ListModel {
        var newItemsList = items
        
        newItemsList[category]?.remove(atOffsets: row)
        
        if let rowList = newItemsList[category] {
            
            if rowList.isEmpty {
                newItemsList.removeValue(forKey: category)
            }
            
        }
        
        return ListModel(id: id, title: title, items: newItemsList, favorite: favorite, owner: owner)
    }
    
    func removeItem(_ item: ItemModel) -> ListModel {
        var newItemsList = items
                
        if let category = newItemsList.first(where: { $0.key.title == item.product.category })?.key,
           let index = newItemsList[category]?.firstIndex(where: { $0.id == item.id }) {
            
            newItemsList[category]?.remove(at: index)
            
            if let categoryItems = newItemsList[category],
               categoryItems.isEmpty {
                newItemsList.removeValue(forKey: category)
            }
        }
                
        return ListModel(id: id, title: title, items: newItemsList, favorite: favorite, owner: owner)
    }
    
    func addComment(_ comment: String, to item: ItemModel) -> ListModel {
        var newItemsList = items
        
        if let category = items.first(where: { $0.key.title == item.product.category }),
           let itemIndex = category.value.firstIndex(where: { $0.id == item.id }),
           let newItem = newItemsList[category.key]?[itemIndex] {
            newItemsList[category.key]?[itemIndex] = newItem.editComment(newComment: comment)
        }
        
        return ListModel(id: id, title: title, items: newItemsList, favorite: favorite, owner: owner)
    }
    
    func toggleCompletion(of item: ItemModel) -> ListModel {
        var newItemsList = items
        
        if let category = items.first(where: { $0.key.title == item.product.category }),
           let itemIndex = category.value.firstIndex(where: { $0.id == item.id }),
           let newItem = newItemsList[category.key]?[itemIndex] {
            newItemsList[category.key]?[itemIndex] = newItem.toggleCompletion()
        }
        
        return ListModel(id: id, title: title, items: newItemsList, favorite: favorite, owner: owner)
    }
}
