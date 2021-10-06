//
//  ModelConverter.swift
//  Superlista
//
//  Created by Marina De Pazzi on 06/10/21.
//

/**
 - name -> ProductModel
 - category -> ProductModel
 
 - Comment -> ItemModel
 - IsCompleted -> ItemModel
 
 - Quantity (new) -> CKItemModel
 */

import Foundation

//MARK: - ModelConverter Class

class ModelConverter {
    
    //MARK: ModelConverter Functions: ☁️ to Local
    
    //MARK: ModelConverter Functions: Local to ☁️
    
    /**
    This method converts our current local ListModel structure to our cloud CKListModel structure
     
     - Parameters:
        - list: the local list to be converted
     - Returns: the CKListModel version of the given ListModel list
     */
    static func convertLocalListToCloud(withList list: ListModel) -> CKListModel {
        let cloudList: CKListModel = CKListModel()
        
        cloudList.name = list.title
        cloudList.itemsModel = Self.convertLocalItemsToCloudItems(withItemsList: list.items)
        
        return CKListModel()
    }
    
    /**
    This method converts our current local ItemModel structure to our cloud CKItemModel structure
     
     - Parameters:
        - items: the local list of items to be converted
     - Returns: the CKItemModel version of the given ItemModel list
     */
    private static func convertLocalItemsToCloudItems(withItemsList items: [CategoryModel: [ItemModel]]) -> [CKItemModel] {
        var cloudItems: [CKItemModel] = []
        
        for item in items {
            let itemCategory: String = item.key.title
            item.value.forEach { localItem in
                let name: String = localItem.product.name
                //let productCategory: String = localItem.product.category
                let comment: String? = localItem.comment
                let isCompleted: Bool = localItem.isCompleted
                cloudItems.append(CKItemModel(name: name, category: itemCategory, quantity: 1, comment: comment, isCompleted: isCompleted))
            }
        }
        
        return cloudItems
    }
    
    static func testConversion() {
        var localItemList: [CategoryModel : [ItemModel]] = [:]
        localItemList = [CategoryModel(id: UUID().uuidString, title: "Categoria Item: HortiFruti 🍓🍇🍉", order: 1) : [
            ItemModel(id: UUID().uuidString, product: ProductModel(id: 999, name: "Banana 🍌", category: "HortiFruti 🍓🍇🍉"), comment: "sem sal", isCompleted: true),
            ItemModel(id: UUID().uuidString, product: ProductModel(id: 997, name: "Maça 🍎", category: "HortiFruti 🍓🍇🍉"), comment: "sem sal", isCompleted: false),
            ItemModel(id: UUID().uuidString, product: ProductModel(id: 996, name: "Alface 🥬", category: "HortiFruti 🍓🍇🍉"), comment: "sem sal", isCompleted: true)]]
        
        let localList: ListModel = ListModel(id: UUID().uuidString, title: "Lista da mari", items: localItemList, favorite: true)
        
        
        for item in localList.items {
            item.value.forEach { localItem in
                print("Comentario do Item: \(localItem.comment!) \n")
                print("Nome do produto: \(localItem.product.name)")
                print("Categoria do produto: \(localItem.product.category) \n")
            }
        }
        print("🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡")
        print("🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴")
        print("convertendo para cloud items")

        let cloudItems = convertLocalItemsToCloudItems(withItemsList: localItemList)
        
        print("🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴")
        print("🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡🟡")
        
        cloudItems.forEach { cloudItem in
            print("Nome do item: \(cloudItem.name) \n")
            print("categoria do item: \(cloudItem.category) \n")
            print("quantidade do item: \(cloudItem.quantity) \n")
            print("comentario do item: \(cloudItem.comment!) \n")
            print("Esta completo? -> \(cloudItem.isCompleted) \n")

        }
    }
    
    
}
