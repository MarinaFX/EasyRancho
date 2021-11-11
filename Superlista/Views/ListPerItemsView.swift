import SwiftUI

struct ListPerItemsView: View {
    
    @EnvironmentObject var dataService: DataService
    
    var list: ListModel
    
    let background = Color("PrimaryBackground")
    
    var categories: [CategoryModel] { dataService.lists.first(where: { $0.id == list.id })!.items.keys.map { $0 } }
    
    func rows(from category: Int) -> [ItemModel] { dataService.lists.first(where: { $0.id == list.id })!.items[categories[category]]! }
    
    func isLast(_ item: ItemModel, from category: CategoryModel) -> Bool {
        return getRows(from: category).last?.id == item.id
    }
    
    func getCategories() -> [CategoryModel] {
        return Array(list.items.keys.map { $0 }).sorted(by: { $0.title < $1.title })
    }
    
    func getRows(from category: CategoryModel) -> [ItemModel] {
        return list.items[category] ?? []
    }
    
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
                        ItemCommentView(item: item, list: list)
                            .padding(.bottom, isLast(item, from: category) ? 8 : 0)
                    }
                    .onDelete { row in
                        dataService.removeItem(from: row, of: category, of: list)
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
}
