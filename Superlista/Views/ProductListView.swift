import SwiftUI

struct ProductListView: View {
    @EnvironmentObject var listsViewModel: DataService
    
    @Binding var filter: String
    @Binding var hasChangedItems: Bool

    @State var selectedItems: [ItemModel] = []
    @State var showCreateNewCustomProductView: Bool = false
    
    let products = ProductListViewModel().productsOrdered
    var list: ListModel

    var filteredProducts: [ProductModel] {
        return products.filter({ $0.name.localizedCaseInsensitiveContains(filter) })
    }
    
    func isSelected(item: ProductModel) -> Bool {
        return selectedItems.contains(where: { $0.product.name == item.name })
    }
    
    var body: some View {
        List {
            ForEach(filter.isEmpty ? products : filteredProducts) { item in
                HStack {
                    Image(systemName: isSelected(item: item) ? "checkmark" : "plus")
                        .foregroundColor(isSelected(item: item) ? Color("Button") : Color.primary)
                        
                    Text(item.name)
                        .foregroundColor(isSelected(item: item) ? Color("Button") : Color.primary)
                        .font(.system(size: 14, weight: isSelected(item: item) ? .bold : .regular))
                    
                    Spacer()
                    
                    //Text("                                           ") gambiarra emergencial
                    
                }
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    if isSelected(item: item),
                       let index = selectedItems.firstIndex(where: { $0.product.name == item.name }) {
                        listsViewModel.removeItem(selectedItems[index], from: list)
                        selectedItems.remove(at: index)
                    } else {
                        let newItem = ItemModel(product: item)
                        listsViewModel.addItem(newItem, to: list)
                        selectedItems.append(newItem)
                    }
                    
                    self.hasChangedItems = !selectedItems.isEmpty
                }
            }
            .listRowBackground(Color("PrimaryBackground"))
            
            if filteredProducts.isEmpty {
                ProductNotFoundView(showCreateNewCustomProductView: self.$showCreateNewCustomProductView)
            }

        }
        .listSeparatorStyle(style: filteredProducts.isEmpty ? .none : .singleLine)
        .listStyle(PlainListStyle())

    }

}
 
struct ProductNotFoundView: View {
    @Binding var showCreateNewCustomProductView: Bool
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("itemNotFoundMessage")
                .foregroundColor(Color("Secondary"))
                .padding(.bottom, 12)
            Button {
                self.showCreateNewCustomProductView.toggle()
            } label: {
                HStack(alignment: .center) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(Color("Button"))
                    
                    Text("itemNotFoundButton")
                        .foregroundColor(Color("Button"))
                        .bold()
                        
                        
                    Spacer()
                }
            }
            .sheet(isPresented: $showCreateNewCustomProductView)
            { }
            content: {
                CreateNewCustomProductView(showCreateNewProductView: self.$showCreateNewCustomProductView)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityHint("ACItemNotFoundButtonHint")
    }
}
