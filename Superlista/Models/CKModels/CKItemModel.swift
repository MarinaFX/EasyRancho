import Foundation

struct CKItemModel {
    let name: String
    let category: String
    let quantity: Int 
    let comment: String?
    let isCompleted: Bool
    
    init(name: String, category: String, quantity: Int, comment: String? = nil, isCompleted: Bool = false) {
        self.name = name 
        self.category = category
        self.quantity = quantity
        self.comment = comment
        self.isCompleted = isCompleted
    }  
    
}
