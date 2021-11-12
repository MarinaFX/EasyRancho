import SwiftUI

struct ProductListView: View {
    @Environment(\.sizeCategory) var sizeCategory
    @EnvironmentObject var dataService: DataService
    
    @Binding var filter: String
    @Binding var hasChangedItems: Bool
    
    @State var selectedItems: [ItemModel] = []
    @State var showCreateNewCustomProductView: Bool = false
    @State var products = ProductListViewModel().productsOrdered
    @State var filteredProducts: [ProductModel] = []
    @State var receivedNewProduct: Bool = false
    
    var list: ListModel
    
    var body: some View {
        List {
            ForEach(filter.isEmpty ? products : filteredProducts) { item in
                //If user is at least on AccessibilityMedium
                //renders the accessibility layout
                if sizeCategory.isAccessibilityCategory {
                    VStack {
                        HStack {
                            ProductListRowView(selectedItems: self.$selectedItems, item: item)
                        }
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
                        
                        if isSelected(item: item) {
                            HStack {
                                ProductQuantityView(selectedItems: self.$selectedItems, list: list, item: item)
                            }
                        }
                    }
                }
                //If user is below AccessibilityMedium
                //renders the normal layout
                else {
                    HStack {
                        ProductListRowView(selectedItems: self.$selectedItems, item: item)
                        
                        if isSelected(item: item) {
                            ProductQuantityView(selectedItems: self.$selectedItems, list: list, item: item)
                        }
                    }
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
            }
            .listRowBackground(Color("PrimaryBackground"))
            
            if (!filter.isEmpty && filteredProducts.isEmpty) {
                ProductNotFoundView(showCreateNewCustomProductView: self.$showCreateNewCustomProductView, receivedNewProduct: $receivedNewProduct)
            }
            
        }
        .listStyle(.plain)

        .onAppear(perform: updateProductListAction)
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
    }
    
    func updateProductListAction() {
        if let customProducts = dataService.user?.customProducts {
            let allProducts = self.products + customProducts
            
            DispatchQueue.main.async {
                self.products = allProducts.sorted(by: { $0.name < $1.name } )
            }
        }
    }
    
    func isSelected(item: ProductModel) -> Bool {
        return selectedItems.contains(where: { $0.product.name == item.name })
    }
}

//MARK: -
struct ProductListRowView: View {
    @Environment(\.sizeCategory) var sizeCategory
    @EnvironmentObject var dataService: DataService

    @Binding var selectedItems: [ItemModel]

    var item: ProductModel
    
    var body: some View {
        if isSelected(item: item) {
            Image(systemName: "checkmark")
                .font(sizeCategory.isAccessibilityCategory ? .footnote : .body)
                .foregroundColor(Color("Button"))
        }
        else {
            ZStack { }.frame(width: 13, height: 13)
        }
        
        Text(item.name)
            .font(.footnote)
            .fontWeight(isSelected(item: item) ? .bold : .regular)
            .foregroundColor(isSelected(item: item) ? Color("Button") : Color.primary)
            .accessibilityLabel(Text("\(item.name)"))
        
        if let customProducts = dataService.user?.customProducts {
            if customProducts.map( { $0.name }).contains(item.name) {
                Button {
                    print("deletou o produto custom")
                } label: {
                    Image(systemName: "trash")
                        .font(.footnote)
                }
                .buttonStyle(.borderless)
            }
        }
        
        Spacer()
        
        if !isSelected(item: item) {
            Image(systemName: "plus")
                .font(sizeCategory.isAccessibilityCategory ? .footnote : .body)
                .foregroundColor(Color.primary)
                .accessibilityLabel(Text("add"))
                .accessibility(hint: Text("Adicione \(item.name)"))
        }
    }
    
    func isSelected(item: ProductModel) -> Bool {
        return selectedItems.contains(where: { $0.product.name == item.name })
    }
}

//MARK: - ProductQuantityView
struct ProductQuantityView: View {
    @EnvironmentObject var dataService: DataService

    @ScaledMetric var symbolSize: CGFloat = 17
    
    @Binding var selectedItems: [ItemModel]
    
    var list: ListModel
    var item: ProductModel
    
    var quantity: Int? {
        if let itemModel = selectedItems.first(where: { $0.product.name == item.name }) {
            return itemModel.quantity
        }
        else {
            return nil
        }
    }

    var body: some View {
        ZStack {
            Image(systemName: "minus.square.fill")
                .resizable()
                .frame(width: symbolSize, height: symbolSize)
                .foregroundColor(quantity ?? 0 > 1 ? Color("Button") : Color(UIColor.secondaryLabel))
        }
        .frame(width: symbolSize, height: symbolSize)
        .onTapGesture {
            let index = selectedItems.firstIndex(where: { $0.product.name == item.name }) ?? 0
            dataService.removeQuantity(of: selectedItems[index], from: list)
            if selectedItems[index].quantity! > 1 {
                selectedItems[index].quantity = selectedItems[index].quantity! - 1
            }
        }
        .accessibilityLabel(Text("remove"))
        .accessibility(hint: Text("removeOneItem"))


        Text("\(quantity ?? 1)")
            .font(.body)
            .foregroundColor(Color.primary)
            .accessibilityLabel(Text("\(quantity ?? 1) items"))


        Image(systemName: "plus.square.fill")
            .resizable()
            .frame(width: symbolSize, height: symbolSize)
            .foregroundColor(Color("Button"))
            .onTapGesture {
                if let index = selectedItems.firstIndex(where: { $0.product.name == item.name }) {
                    dataService.addQuantity(of: selectedItems[index], from: list)
                    selectedItems[index].quantity = (selectedItems[index].quantity ?? 1) + 1
                }
                
            }
            .accessibilityLabel(Text("add"))
            .accessibility(hint: Text("addOneItem"))
    }
}

//MARK: - ProductNotFoundView
struct ProductNotFoundView: View {
    @Binding var showCreateNewCustomProductView: Bool
    @Binding var receivedNewProduct: Bool
        
    var body: some View {
        VStack (alignment: .leading) {
            Text("itemNotFoundMessage")
                .font(.body)
                .foregroundColor(Color("Secondary"))
                .padding(.bottom, 12)
            
            Button {
                self.showCreateNewCustomProductView.toggle()
            } label: {
                HStack(alignment: .center) {
                    Image(systemName: "plus.circle.fill")
                        .font(.body)
                        .foregroundColor(Color("Button"))
                    
                    Text("itemNotFoundButton")
                        .font(.body)
                        .bold()
                        .foregroundColor(Color("Button"))
                    
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
