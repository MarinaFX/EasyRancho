import SwiftUI

struct ProductListView: View {
    @EnvironmentObject var listsViewModel: DataService
    
    let products = ProductListViewModel().productsOrdered
    
    var list: ListModel

    @State var selectedItems: [ItemModel] = []
        
    @Binding var filter: String
    
    @Binding var hasChangedItems: Bool
    
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
                    if isSelected(item: item) {
                        Image(systemName: "checkmark")
                            .foregroundColor(Color("Button"))
                            .frame(width: 13, height: 13)
                    } else {
                        ZStack {
                        }
                        .frame(width: 13, height: 13)
                    }
                        
                    Text(item.name)
                        .foregroundColor(isSelected(item: item) ? Color("Button") : Color.primary)
                        .font(.system(size: 14, weight: isSelected(item: item) ? .bold : .regular))
                    
                    Spacer()
                    
                    if !isSelected(item: item) {
                        Image(systemName: "plus")
                            .foregroundColor(Color.primary)
                            .frame(width: 13, height: 13)
                    } else {
                        ZStack {
                            Image(systemName: "minus.square.fill")
                                .resizable()
                                .frame(width: 17, height: 17)
                                .foregroundColor(Color("Button"))
                        }
                        .frame(width: 17, height: 17)
                        .onTapGesture {
                            let index = selectedItems.firstIndex(where: { $0.product.name == item.name })
                            listsViewModel.removeQuantity(of: selectedItems[index!], from: list)
                        }

                        
                        Text("\(selectedItems[selectedItems.firstIndex(where: { $0.product.name == item.name })!].quantity!)")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(Color.primary)
                        
                        
                        Image(systemName: "plus.square.fill")
                            .resizable()
                            .frame(width: 17, height: 17)
                            .foregroundColor(Color("Button"))
                            .onTapGesture {
                                let index = selectedItems.firstIndex(where: { $0.product.name == item.name })
                                listsViewModel.addQuantity(of: selectedItems[index!], from: list)
                            }
                    }
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
        }
        .listStyle(PlainListStyle())
    }
}
 
