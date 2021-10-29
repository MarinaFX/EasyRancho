import Foundation

//MARK: - ItemModelConverter Class

/**
 ItemModelConverter is a Bridge class converting our Cloud record/class of Item arquitecture to our local/UserDefaults class arquitecture.
 
 According to its formal definition, a Bridge is something that meakes its easier to change from one situation to another. In this case, instead of refactoring the whole backend everytime we make a new implementation of a service, a Bridge class connects both arquitectures by parsing each to each. This way is possible to manipulate both strcutures without backend refactoring.
 */
class ItemModelConverter {
    
    //MARK: ItemModelConverter Functions: ☁️ to Local
    
    /**
    This method converts our current cloud CKItemModel structure to our local ItemModel structure
     
     - Parameters:
        - items: the cloud list of items to be converted
     - Returns: the ItemModel version of the given CKItemModel list
     */
    func convertCloudItemsToLocal(withItems items: [CKItemModel]) -> [CategoryModel : [ItemModel]] {
        var localItems: [CategoryModel: [ItemModel]] = [:]
        var onlyItems: [ItemModel] = []
        
        items.forEach { item in
            let product: ProductModel = ProductModel(id: 999, name: item.name, category: item.category)
            let localItem: ItemModel = ItemModel(id: UUID().uuidString, product: product, comment: item.comment, isCompleted: item.isCompleted, quantity: item.quantity)
            
            onlyItems.append(localItem)
        }
        
        let allCategories = onlyItems.map { $0.product.category }
        let categorySet = Set(allCategories)
        
        for category in categorySet {
            let categoryUUID = UUID().uuidString

            let itemsOfCategory = onlyItems.filter { $0.product.category == category }
            let categoryModel = CategoryModel(id: categoryUUID, title: category)
            localItems[categoryModel] = itemsOfCategory
        }
        

        return localItems
    }
    
    //MARK: ItemModelConverter Functions: Local to ☁️
    
    /**
    This method converts our current local ItemModel structure to our cloud CKItemModel structure
     
     - Parameters:
        - items: the local list of items to be converted
     - Returns: the CKItemModel version of the given ItemModel list
     */
    func convertLocalItemsToCloudItems(withItemsList items: [CategoryModel: [ItemModel]]) -> [CKItemModel] {
        var cloudItems: [CKItemModel] = []
        
        for item in items {
            let itemCategory: String = item.key.title
            item.value.forEach { localItem in
                let name: String = localItem.product.name
                let comment: String? = localItem.comment
                let isCompleted: Bool = localItem.isCompleted
                let quantity: Int = localItem.quantity ?? 1
                cloudItems.append(CKItemModel(name: name, category: itemCategory, quantity: quantity, comment: comment, isCompleted: isCompleted))
            }
        }
        
        return cloudItems
    }
    
    //MARK: ItemModelConverter String to CKItemObject
    
    func parseStringToCKItemObject(withString items: [String]) -> [CKItemModel] {
        var cloudItems: [CKItemModel] = []
        
        for item in items {
            let contents = item.components(separatedBy: ";")
            let name = contents[0] as String
            let category = contents[1] as String
            let quantity = (Int(contents[2]) ?? 1) as Int
            let comment = contents[3] == "nil" ? nil : contents[3]
            let isCompleted = contents[4] == "true" ? true : false
            let item = CKItemModel(name: name, category: category, quantity: quantity, comment: comment, isCompleted: isCompleted)
            
            cloudItems.append(item)
        }
        
        return cloudItems
    }
    
    
    func parseCKItemObjectToString(withItems items: [CKItemModel]) -> [String] {
        var itemsString: [String] = []
        
        items.forEach { item in
            var comment = "nil"
            
            if let itemComment = item.comment, itemComment != "" {
                comment = itemComment
            }
            
            itemsString.append("\(item.name);\(item.category);\(item.quantity);\(comment);\(item.isCompleted)")
        }
        
        return itemsString
    }
}
