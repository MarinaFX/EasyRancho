import Foundation

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
            
            #warning("ver a necessidade de subir o ID do produto para o banco de dados")
            let newProduct: ProductModel = ProductModel(id: 935, name: name, category: category)
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
}
