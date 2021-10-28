import Foundation

struct ItemModel: Identifiable, Codable {
    let id: String
    let product: ProductModel
    let comment: String?
    let isCompleted: Bool
    var quantity: Int?
    
    init(id: String = UUID().uuidString, product: ProductModel, comment: String? = nil, isCompleted: Bool = false, quantity: Int? = 1) {
        self.id = id
        self.product = product
        self.comment = comment
        self.isCompleted = isCompleted
        self.quantity = quantity
    }
    
    func toggleCompletion() -> ItemModel {
        return ItemModel(id: id, product: product, comment: comment, isCompleted: !isCompleted)
    }

    func editComment(newComment: String) -> ItemModel {
        return ItemModel(id: id, product: product, comment: newComment, isCompleted: isCompleted)
    }
    
     func addQuantity() -> ItemModel {
        let newQuantity = (quantity ?? 1) + 1
        return ItemModel(id: id, product: product, comment: comment, isCompleted: isCompleted, quantity: newQuantity)
    }
    
    func removeQuantity() -> ItemModel {
        guard let quantity = quantity else {
            return ItemModel(id: id, product: product, comment: comment, isCompleted: isCompleted, quantity: quantity)}
        if quantity > 1 {
            let newQuantity = quantity - 1
            return ItemModel(id: id, product: product, comment: comment, isCompleted: isCompleted, quantity: newQuantity)
        } else {
            return ItemModel(id: id, product: product, comment: comment, isCompleted: isCompleted, quantity: quantity)
        }
    }
}
