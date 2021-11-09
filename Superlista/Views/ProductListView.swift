import SwiftUI

struct ProductListView: View {
    @EnvironmentObject var dataService: DataService
    
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
                        .accessibilityLabel(Text("\(item.name)"))
                    
                    Spacer()
                    
                    if !isSelected(item: item) {
                        Image(systemName: "plus")
                            .foregroundColor(Color.primary)
                            .frame(width: 13, height: 13)
                            .accessibilityLabel(Text("add"))
                            .accessibility(hint: Text("Adicione \(item.name)"))
                    } else {
                        ZStack {
                            Image(systemName: "minus.square.fill")
                                .resizable()
                                .frame(width: 17, height: 17)
                                .foregroundColor((selectedItems[selectedItems.firstIndex(where: { $0.product.name == item.name }) ?? 0].quantity ?? 0 > 1) ? Color("Button") : Color(UIColor.secondaryLabel))
                        }
                        .frame(width: 17, height: 17)
                        .onTapGesture {
                            let index = selectedItems.firstIndex(where: { $0.product.name == item.name }) ?? 0
                            dataService.removeQuantity(of: selectedItems[index], from: list)
                            if selectedItems[index].quantity! > 1 {
                                selectedItems[index].quantity = selectedItems[index].quantity! - 1
                            }
                        }
                        .accessibilityLabel(Text("remove"))
                        .accessibility(hint: Text("removeOneItem"))

                        
                        Text("\(selectedItems[selectedItems.firstIndex(where: { $0.product.name == item.name }) ?? 0].quantity ?? 1)")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(Color.primary)
                            .accessibilityLabel(Text("\(selectedItems[selectedItems.firstIndex(where: { $0.product.name == item.name }) ?? 0].quantity ?? 1) items"))
                        
                        
                        Image(systemName: "plus.square.fill")
                            .resizable()
                            .frame(width: 17, height: 17)
                            .foregroundColor(Color("Button"))
                            .onTapGesture {
                                let index = selectedItems.firstIndex(where: { $0.product.name == item.name }) ?? 0
                                dataService.addQuantity(of: selectedItems[index], from: list)
                                selectedItems[index].quantity = (selectedItems[index].quantity ?? 1) + 1
                            }
                            .accessibilityLabel(Text("add"))
                            .accessibility(hint: Text("addOneItem"))
                    }
                }
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    let index = selectedItems.firstIndex(where: { $0.product.name == item.name }) ?? 0
                    if isSelected(item: item){
                        dataService.removeItem(selectedItems[index], from: list)
                        selectedItems.remove(at: index)
                    } else {
                        let newItem = ItemModel(product: item)
                        dataService.addItem(newItem, to: list)
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
 
