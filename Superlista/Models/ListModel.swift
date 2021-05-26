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
    
//    func addItem(_ product: ProductModel) -> ListModel {
//        var newItemsList = items
//                
//        if let _ = items[product.getCategory()] {
//            newItemsList[product.getCategory()]?.append(ItemModel(product: product))
//        } else {
//            newItemsList[product.getCategory()] = [ItemModel(product: product)]
//        }
//                
//        return ListModel(id: id, title: title, items: newItemsList, favorite: favorite)
//    }
    
    func addItem(_ item: ItemModel) -> ListModel {
        var newItemsList = items
                
        if let category = newItemsList.first(where: { $0.key.title == item.product.category })?.key {
            newItemsList[category]?.append(item)
        } else {
            newItemsList[CategoryModel(title: item.product.category, order: newItemsList.count + 1)] = [item]
        }
                
        return ListModel(id: id, title: title, items: newItemsList, favorite: favorite)
    }
    
//    func addItems(_ products: [ProductModel]) -> ListModel {
//        var newItemsList = items
//        
//        products.forEach { product in
//            if let category = newItemsList.first(where: { $0.key.title == product.category })?.key {
//                newItemsList[category]?.append(ItemModel(product: product))
//            } else {
//                newItemsList[CategoryModel(title: product.category, order: newItemsList.count + 1)] = [ItemModel(product: product)]
//            }
//        }
//        
//        return ListModel(id: id, title: title, items: newItemsList, favorite: favorite)
//    }
    
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
                
        return ListModel(id: id, title: title, items: newItemsList, favorite: favorite)
    }
    
    func addComment(_ comment: String, to item: ItemModel) -> ListModel {
        var newItemsList = items
        
        if let category = items.first(where: { $0.key.title == item.product.category }),
           let itemIndex = category.value.firstIndex(where: { $0.id == item.id }),
           let newItem = newItemsList[category.key]?[itemIndex] {
            newItemsList[category.key]?[itemIndex] = newItem.editComment(newComment: comment)
        }
        
        return ListModel(id: id, title: title, items: newItemsList, favorite: favorite)
    }
    
    func toggleCompletion(of item: ItemModel) -> ListModel {
        var newItemsList = items
        
        if let category = items.first(where: { $0.key.title == item.product.category }),
           let itemIndex = category.value.firstIndex(where: { $0.id == item.id }),
           let newItem = newItemsList[category.key]?[itemIndex] {
            newItemsList[category.key]?[itemIndex] = newItem.toggleCompletion()
        }
        
        return ListModel(id: id, title: title, items: newItemsList, favorite: favorite)
    }

    func switchOrder(from cat1: CategoryModel, to cat2: CategoryModel) -> ListModel {
        var newListItem: [CategoryModel : [ItemModel]] = [:]
        
        if let category1 = items.first(where: { $0.key.id == cat1.id }),
           let category2 = items.first(where: { $0.key.id == cat2.id }),
           let order2 = category2.key.order,
           let order1 = category1.key.order {
            
            let difference = order1 - order2
            let newOrder = order2
            
            var before: Array<(key: CategoryModel, value: Array<ItemModel>)>
            var after: Array<(key: CategoryModel, value: Array<ItemModel>)>
            
            if difference < 0 {
                before = items
                    .filter { ($0.key.order ?? 0 <= newOrder) && ($0.key.id != category1.key.id) }
                    .sorted(by: { $0.key.order ?? 0 < $1.key.order ?? 0 })
                
                after = items
                    .filter { $0.key.order ?? 0 > newOrder }
                    .sorted(by: { $0.key.order ?? 0 < $1.key.order ?? 0 })
                
                
            } else {
                before = items
                    .filter { $0.key.order ?? 0 < newOrder }
                    .sorted(by: { $0.key.order ?? 0 < $1.key.order ?? 0 })
                
                after = items
                    .filter { ($0.key.order ?? 0 >= newOrder) && ($0.key.id != category1.key.id) }
                    .sorted(by: { $0.key.order ?? 0 < $1.key.order ?? 0 })
            }
            
            before.forEach { item in
                newListItem[CategoryModel(id: item.key.id, title: item.key.title, order: newListItem.count + 1)] = item.value
            }
            
            newListItem[CategoryModel(id: category1.key.id, title: category1.key.title, order: newOrder)] = category1.value
            
            after.forEach { item in
                newListItem[CategoryModel(id: item.key.id, title: item.key.title, order: newListItem.count + 1)] = item.value
            }
        }
        
        return ListModel(id: id, title: title, items: newListItem, favorite: favorite)
    }
}
