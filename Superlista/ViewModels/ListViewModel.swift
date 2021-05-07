import Foundation

class ListViewModel: ObservableObject {
    let products = ProductListViewModel().products
    
    @Published var list: [String : [ItemModel]] = [:] {
        didSet {
            saveItems()
        }
    }
        
    let itemsKey: String = "list"
    
    init() {
        getItems()
    }
    
    func getItems() {
        guard
            let data = UserDefaults.standard.data(forKey: itemsKey),
            let savedItems = try? JSONDecoder().decode([String : [ItemModel]].self, from: data)
        else { return }
        
        self.list = savedItems
    }
    
    func addItem(product: ProductModel) {
        if let _ = list[product.category] {
            list[product.category]?.append(ItemModel(product: product))
        } else {
            list[product.category] = [ItemModel(product: product)]
        }
    }
    
    func saveItems() {
        if let encodedData = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(encodedData, forKey: itemsKey)
        }
    }
    
    var categories: [String] { list.keys.map { $0 } }
    
    func rows(from category: Int) -> [ItemModel] { list[categories[category]]! }
    
    func deleteItem(from row: IndexSet, of category: Int) {
        list[categories[category]]?.remove(atOffsets: row)
        
        if rows(from: category).count == 0 {
            list.removeValue(forKey: categories[category])
        }
    }
    
    func addComment(_ comment: String, to item: ItemModel, from category: Int) {
        if let index = rows(from: category).firstIndex(where: { $0.id == item.id }) {
            list[categories[category]]?[index] = item.editComment(newComment: comment)
        }
    }
    
    func toggleCompletion(of item: ItemModel, from category: Int) {
        if let index = rows(from: category).firstIndex(where: { $0.id == item.id }) {
            list[categories[category]]?[index] = item.toggleCompletion()
        }
    }
}
