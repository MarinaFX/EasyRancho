//
//  ListModel.swift
//  Superlista
//
//  Created by Thaís Fernandes on 10/05/21.
//

import Foundation

struct ListModel: Identifiable, Decodable, Encodable {
    let id: String
    let title: String
    let items: [CategoryModel: [ItemModel]]
    let favorite: Bool
    
    init(id: String = UUID().uuidString, title: String, items: [CategoryModel: [ItemModel]] = [:], favorite: Bool = false) {
        
        self.id = id
        self.title = title
        self.items = items
        self.favorite = favorite
    }
    
    func toggleFavorite() -> ListModel {
        return ListModel(id: id, title: title, items: items, favorite: !favorite)
    }
    
    func editTitle(newTitle: String) -> ListModel {
        return ListModel(id: id, title: newTitle, items: items, favorite: favorite)
    }
    
    func addItem(_ product: ProductModel) -> ListModel {
        var newItemsList = items
        
        if let _ = items[product.getCategory()] {
            newItemsList[product.getCategory()]?.append(ItemModel(product: product))
        } else {
            newItemsList[product.getCategory()] = [ItemModel(product: product)]
        }
        
        return ListModel(id: id, title: title, items: newItemsList, favorite: favorite)
    }
    
    func addItems(_ products: [ProductModel]) -> ListModel {
        var newItemsList = items
        
        products.forEach { product in
            if let category = newItemsList.first(where: { $0.key.title == product.category })?.key {
                newItemsList[category]?.append(ItemModel(product: product))
            } else {
                let lastOrder = Array(newItemsList.keys).last?.order
                newItemsList[CategoryModel(title: product.category, order: (lastOrder ?? 0) + 1)] = [ItemModel(product: product)]
            }
        }
        
        return ListModel(id: id, title: title, items: newItemsList, favorite: favorite)
    }
    
    func removeItem(from row: IndexSet, of category: CategoryModel) -> ListModel {
        var newItemsList = items
        
        newItemsList[category]?.remove(atOffsets: row)
        
        if let rowList = newItemsList[category] {
            
            if rowList.isEmpty {
                newItemsList.removeValue(forKey: category)
            }
            
        }
        
        return ListModel(id: id, title: title, items: newItemsList, favorite: favorite)
    }
    
    func addComment(_ comment: String, to item: ItemModel) -> ListModel {
        
        var newItemsList = items
        
        if let rows = items[item.product.getCategory()],
           let index = rows.firstIndex(where: { $0.id == item.id }) {
            
            newItemsList[item.product.getCategory()]?[index] = item.editComment(newComment: comment)
        }
        
        return ListModel(id: id, title: title, items: newItemsList, favorite: favorite)
    }
    
    func toggleCompletion(of item: ItemModel) -> ListModel {
        
        var newItemsList = items
        
        if let rows = items[item.product.getCategory()],
           let index = rows.firstIndex(where: { $0.id == item.id }) {
            
            newItemsList[item.product.getCategory()]?[index] = item.toggleCompletion()
        }
        
        return ListModel(id: id, title: title, items: newItemsList, favorite: favorite)
    }
    
    func switchOrder(from cat1: CategoryModel, to cat2: CategoryModel) -> ListModel {
        var newItemsList = items
        
        if let category1 = items.first(where: { $0.key.id == cat1.id }),
           let category2 = items.first(where: { $0.key.id == cat2.id }){
            newItemsList.removeValue(forKey: category1.key)
            newItemsList.removeValue(forKey: category2.key)
                
            newItemsList[CategoryModel(id: category1.key.id, title: category1.key.title, order: category2.key.order)] = category1.value
            newItemsList[CategoryModel(id: category2.key.id, title: category2.key.title, order: category1.key.order)] = category2.value
        }
        
        return ListModel(id: id, title: title, items: newItemsList, favorite: favorite)
    }
    
//    func switchCategories(from: CategoryModel, to: CategoryModel) -> ListModel {
//        var newItemsList = items
//        
//        let fromList = newItemsList[from]
//        newItemsList[from] = newItemsList[to]
//        newItemsList[to] = fromList
//        
//        return ListModel(id: id, title: title, items: newItemsList, favorite: favorite)
//    }
}
