import Foundation

class ProductListViewModel {
    
    public let products: [ProductModel]
    let productsOrdered: [ProductModel]
        
    init() {
        self.products = load("productList.json")
        self.productsOrdered = products.sorted(by: { $0.name < $1.name })
    }
    
}
