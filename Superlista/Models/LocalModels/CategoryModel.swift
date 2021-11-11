import Foundation

struct CategoryModel: Decodable, Hashable, Encodable {
    let id: String
    let title: String
    
    init(id: String = UUID().uuidString, title: String) {
        self.id = id
        self.title = title
    }
    
    func setOrder(newOrder: Int) -> CategoryModel {
        return CategoryModel(id: id, title: title)
    }
}

