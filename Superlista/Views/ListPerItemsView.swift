import SwiftUI

struct ListPerItemsView: View {
    @EnvironmentObject var dataService: DataService
    
    let background = Color("PrimaryBackground")
    
    @Binding var list: ListModel?
    var categories: [CategoryModel] { list?.items.keys.map { $0 } ?? [] }
    
    var body: some View {
        List {
            ForEach(getCategories(), id: \.self) { category in
                
                Section(header: HStack {
                    Text(category.title)
                        .font(.headline)
                        .foregroundColor(getColor(category: category.title))
                        .padding()
                        .accessibility(hint: Text("CategoryTitleHint"))
                        .accessibilityRemoveTraits(AccessibilityTraits.isHeader)
                    
                    Spacer()
                }
                            .frame(maxHeight: 30)
                            .textCase(nil) // TALVEZ TENHA QUE TIRAR
                            .background(Color("PrimaryBackground"))
                            .listRowInsets(EdgeInsets(
                                top: 0,
                                leading: 0,
                                bottom: -10,
                                trailing: 0))
                        
                ) {
                    ForEach(getRows(from: category)) { item in
                        ItemCommentView(item: item, list: self.$list)
                            .padding(.bottom, isLast(item, from: category) ? 8 : 0)
                    }
                    .onDelete { row in
                        if let list = list {
                            let newList = list.removeItem(from: row, of: category)
                            self.list = newList
                        }
                    }
                    .listRowBackground(Color("PrimaryBackground"))
                }
            }
            .listRowBackground(Color("PrimaryBackground"))
        }
        .listStyle(PlainListStyle())
        .onAppear {
            UITableView.appearance().showsVerticalScrollIndicator = false
        }
    }
    
    func rows(from category: Int) -> [ItemModel] { list?.items[categories[category]] ?? [] }
    
    func isLast(_ item: ItemModel, from category: CategoryModel) -> Bool { getRows(from: category).last?.id == item.id }
    
    func getCategories() -> [CategoryModel] {
        if let list = list {
            return Array(list.items.keys.map { $0 }).sorted(by: { $0.title < $1.title })
        }
        return []
    }
    
    func getRows(from category: CategoryModel) -> [ItemModel] { list?.items[category] ?? [] }
}
