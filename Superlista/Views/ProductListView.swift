import SwiftUI

struct ProductListView: View {
    @EnvironmentObject var dataService: DataService
    
    @Binding var filter: String
    @Binding var hasChangedItems: Bool

    @State var selectedItems: [ItemModel] = []
    @State var showCreateNewCustomProductView: Bool = false
    @State var products = ProductListViewModel().productsOrdered
    
    var list: ListModel

    @State var filteredProducts: [ProductModel] = []
    @State var receivedNewProduct: Bool = false
    
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
            
            if filteredProducts.isEmpty {
                ProductNotFoundView(showCreateNewCustomProductView: self.$showCreateNewCustomProductView, receivedNewProduct: $receivedNewProduct)
            }

        }
        .onAppear(perform: {
            if let customProducts = dataService.user?.customProducts {
                let allProducts = products + customProducts
                
                DispatchQueue.main.async {
                    products = allProducts.sorted(by: { $0.name < $1.name } )
                }
            }
            
        })
        .onChange(of: receivedNewProduct, perform: { newProduct in
            if let customProducts = dataService.user?.customProducts {
                let allProducts = products + customProducts
                
                DispatchQueue.main.async {
                    products = allProducts.sorted(by: { $0.name < $1.name } )
                    
                    self.filteredProducts = products.filter( { $0.name.localizedCaseInsensitiveContains(filter) } )
                }
            }
        })
        .onChange(of: filter, perform: { newFilter in
            self.filteredProducts = products.filter( { $0.name.localizedCaseInsensitiveContains(newFilter) } )
        })
        .listSeparatorStyle(style: filteredProducts.isEmpty ? .none : .singleLine)
        .listStyle(PlainListStyle())

    }
}
 
struct ProductNotFoundView: View {
    @Binding var showCreateNewCustomProductView: Bool
    @Binding var receivedNewProduct: Bool
    
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
                CreateNewCustomProductView(showCreateNewProductView: self.$showCreateNewCustomProductView, didCreateNewProduct: $receivedNewProduct)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityHint("ACItemNotFoundButtonHint")
    }
}
