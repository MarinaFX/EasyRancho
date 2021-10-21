import Foundation

struct ProductModel : Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var category: String
    
    func getCategory() -> CategoryModel {
        return CategoryModel(title: category)
    }
}
