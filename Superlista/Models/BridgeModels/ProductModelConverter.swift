import Foundation
import SwiftUI

//MARK: - ProductModelConverter Class

/**
 
 */
class ProductModelConverter {
    
    func convertStringToProducts(withString string: [String]) -> [ProductModel] {
        var localProduct: [ProductModel] = []
    
        for product in string {
            let contents = product.components(separatedBy: ";")

            let name: String = contents[0]
            let category: String = contents[1]
            
            let newProduct: ProductModel = ProductModel(id: random(), name: name, category: category)
            localProduct.append(newProduct)
        }
        
        
        return localProduct
    }
    
    func convertLocalProductsToString(withProducts products: [ProductModel]) -> [String] {
        var cloudProducts: [String] = []
        
        for product in products {
            let newProduct: String = product.name + ";" + product.category
            cloudProducts.append(newProduct)
        }
        
        return cloudProducts
    }
    
    func convertLocalProductsToString(withProduct product: ProductModel) -> String {
        var cloudProduct: String = ""
        
        cloudProduct = product.name + ";" + product.category
        
        return cloudProduct
    }
}
