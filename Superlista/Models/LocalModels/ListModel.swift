import Foundation
import CloudKit

struct ListModel: Identifiable, Decodable, Encodable, Equatable {
    static func == (lhs: ListModel, rhs: ListModel) -> Bool {
        let sameId = lhs.id == rhs.id
        let sameItems = lhs.items == rhs.items
        return sameId && sameItems
    }
    
    var id: String
    var title: String
    var items: [CategoryModel: [ItemModel]]
    
    var owner: OwnerModel
    var sharedWith: [OwnerModel]?
    
    init(title: String, items: [CategoryModel: [ItemModel]] = [:], owner: OwnerModel, sharedWith: [OwnerModel] = []) {
        let recordID = CKRecord.ID()
        
        self.id = recordID.recordName
        self.title = title
        self.items = items
        self.owner = owner
        self.sharedWith = sharedWith
    }
    
    init(id: String, title: String, items: [CategoryModel: [ItemModel]] = [:], owner: OwnerModel, sharedWith: [OwnerModel] = []) {
        self.id = id
        self.title = title
        self.items = items
        self.owner = owner
        self.sharedWith = sharedWith
    }
    
    func editTitle(newTitle: String) -> ListModel {
        return ListModel(id: id, title: newTitle, items: items, owner: owner)
    }
    
    func addItem(_ item: ItemModel) -> ListModel {
        var newItemsList = items
        
        if let category = newItemsList.first(where: { $0.key.title == item.product.category })?.key {
            newItemsList[category]?.append(item)
        } else {
            newItemsList[CategoryModel(title: item.product.category)] = [item]
        }
        
        return ListModel(id: id, title: title, items: newItemsList, owner: owner)
    }
    
    func removeItem(from row: IndexSet, of category: CategoryModel) -> ListModel {
        var newItemsList = items
        
        newItemsList[category]?.remove(atOffsets: row)
        
        if let rowList = newItemsList[category] {
            
            if rowList.isEmpty {
                newItemsList.removeValue(forKey: category)
            }
            
        }
        
        return ListModel(id: id, title: title, items: newItemsList, owner: owner)
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
        
        return ListModel(id: id, title: title, items: newItemsList, owner: owner)
    }
    
    func addComment(_ comment: String, to item: ItemModel) -> ListModel {
        var newItemsList = items
        
        if let category = items.first(where: { $0.key.title == item.product.category }),
           let itemIndex = category.value.firstIndex(where: { $0.id == item.id }),
           let newItem = newItemsList[category.key]?[itemIndex] {
            newItemsList[category.key]?[itemIndex] = newItem.editComment(newComment: comment)
        }
        
        return ListModel(id: id, title: title, items: newItemsList, owner: owner)
    }
    
    func toggleCompletion(of item: ItemModel) -> ListModel {
        var newItemsList = items
        
        if let category = items.first(where: { $0.key.title == item.product.category }),
           let itemIndex = category.value.firstIndex(where: { $0.id == item.id }),
           let newItem = newItemsList[category.key]?[itemIndex] {
            newItemsList[category.key]?[itemIndex] = newItem.toggleCompletion()
        }
        
        return ListModel(id: id, title: title, items: newItemsList, owner: owner)
    }
    
    func addQuantity(of item: ItemModel) -> ListModel {
        var newItemsList = items
        
        if let category = items.first(where: { $0.key.title == item.product.category }),
           let itemIndex = category.value.firstIndex(where: { $0.id == item.id }),
           let newItem = newItemsList[category.key]?[itemIndex] {
            newItemsList[category.key]?[itemIndex] = newItem.addQuantity(quantity: item.quantity ?? 1)
        }
        
        return ListModel(id: id, title: title, items: newItemsList, owner: owner)
    }
    
    func removeQuantity(of item: ItemModel) -> ListModel {
        var newItemsList = items
        
        if let category = items.first(where: { $0.key.title == item.product.category }),
           let itemIndex = category.value.firstIndex(where: { $0.id == item.id }),
           let newItem = newItemsList[category.key]?[itemIndex] {
            newItemsList[category.key]?[itemIndex] = newItem.removeQuantity(quantity: item.quantity ?? 1)
        }
        
        return ListModel(id: id, title: title, items: newItemsList, owner: owner)
    }
}
