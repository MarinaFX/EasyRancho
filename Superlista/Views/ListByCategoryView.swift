import SwiftUI

struct ListByCategoryView: View {
    @EnvironmentObject var listsViewModel: DataService
    
    var categoryName: CategoryModel
    
    var list: ListModel
    
    func rows() -> [ItemModel] { listsViewModel.lists.first(where: { $0.id == list.id })!.items[categoryName]! }
    
    var body: some View {
        MainScreen(customView: AnyView(
            VStack (alignment: .leading) {
                
                VStack(alignment: .leading) {
                    
                    Text(categoryName.title).font(.system(size: 24, weight: .bold))
                        .lineLimit(2)
                        .foregroundColor(getColor(category: categoryName.title))
                    
                
                }
                .padding(.leading, 20)
                .padding(.trailing, 10)
                
                
                List {
                    ForEach(rows()) { item in
                        ItemCommentView(item: item, list: list)
                    }
                    .onDelete { row in
                        listsViewModel.removeItem(from: row, of: categoryName, of: list)
                    }
                    .listRowBackground(Color("background"))
                    
                }
            }
        ))
    }
}
