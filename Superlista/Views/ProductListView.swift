import SwiftUI

struct ProductListView: View {
    @Environment(\.sizeCategory) var sizeCategory
    @EnvironmentObject var dataService: DataService
    
    @Binding var filter: String
    @Binding var list: ListModel?

    @State var selectedItems: [ItemModel] = []
    @State var showCreateNewCustomProductView: Bool = false
    @State var products = ProductListViewModel().productsOrdered
    @State var filteredProducts: [ProductModel] = []
    @State var receivedNewProduct: Bool = false
    @State var deletedCustomProduct: Bool = false
    
    var body: some View {
        List {
            ForEach(filter.isEmpty ? products : filteredProducts) { item in
                //If user is at least on AccessibilityMedium
                //renders the accessibility layout
                if sizeCategory.isAccessibilityCategory {
                    VStack {
                        HStack {
                            ProductListRowView(selectedItems: self.$selectedItems, didDeleteCustomProduct: self.$deletedCustomProduct, item: item)
                        }
                        .onTapGesture {
                            let index = selectedItems.firstIndex(where: { $0.product.name == item.name }) ?? 0
                            if isSelected(item: item){
                                if let list = list {
                                    let newList = list.removeItem(selectedItems[index])
                                    self.list = newList
                                }
                                selectedItems.remove(at: index)
                            } else {
                                let newItem = ItemModel(product: item)
                                if let list = list {
                                    let newList = list.addItem(newItem)
                                    self.list = newList
                                }
                                selectedItems.append(newItem)
                            }
                        }
                        
                        if isSelected(item: item) {
                            HStack {
                                ProductQuantityView(selectedItems: self.$selectedItems, list: self.$list, item: item)
                            }
                        }
                    }
                }
                //If user is below AccessibilityMedium
                //renders the normal layout
                else {
                    HStack {
                        ProductListRowView(selectedItems: self.$selectedItems, didDeleteCustomProduct: self.$deletedCustomProduct, item: item)
                        
                        if isSelected(item: item) {
                            ProductQuantityView(selectedItems: self.$selectedItems, list: self.$list, item: item)
                        }
                    }
                    .onTapGesture {
                        let index = selectedItems.firstIndex(where: { $0.product.name == item.name }) ?? 0
                        if isSelected(item: item){
                            if let list = list {
                                let newList = list.removeItem(selectedItems[index])
                                self.list = newList
                            }
                            selectedItems.remove(at: index)
                        } else {
                            let newItem = ItemModel(product: item)
                            if let list = list {
                                let newList = list.addItem(newItem)
                                self.list = newList
                            }
                            selectedItems.append(newItem)
                        }
                    }
                }
            }
            .listRowBackground(Color("PrimaryBackground"))
            
            if (!filter.isEmpty && filteredProducts.isEmpty) {
                ProductNotFoundView(showCreateNewCustomProductView: self.$showCreateNewCustomProductView, receivedNewProduct: $receivedNewProduct)
            }
            
        }
        .listStyle(.plain)
        .onAppear(perform: { updateProductListAction() })
        .onChange(of: receivedNewProduct, perform: { _ in
            updateProductListAction()
            
            DispatchQueue.main.async {
                self.filteredProducts = products.filter( { $0.name.localizedCaseInsensitiveContains(filter) } )
            }
        })
        .onChange(of: deletedCustomProduct, perform: { _ in
            updateProductListAction()

            DispatchQueue.main.async {
                self.filteredProducts = products.filter( { $0.name.localizedCaseInsensitiveContains(filter) } )
            }
        })
        .onChange(of: filter, perform: { newFilter in
            self.filteredProducts = products.filter( { $0.name.localizedCaseInsensitiveContains(newFilter) } )
        })
    }
    
    func updateProductListAction() {
        if let customProducts = dataService.user?.customProducts {
            self.products = ProductListViewModel().productsOrdered
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
    @Binding var didDeleteCustomProduct: Bool

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
                    deleteCustomProductAction(item)
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
    
    func deleteCustomProductAction(_ item: ProductModel) {
        alertMessage(title: NSLocalizedString("deletionAlertTitle", comment: ""),
                     message: NSLocalizedString("deletionAlertMessage", comment: ""),
                     actions: [
            UIAlertAction(title: NSLocalizedString("deletionAlertDestructive", comment: ""),
                          style: .destructive,
                          handler: { _ in
                let didDeleteProductSuccessfully = dataService.deleteCustomProduct(of: item)
                if didDeleteProductSuccessfully {
                    self.didDeleteCustomProduct.toggle()
                }
            }),
            UIAlertAction(title: NSLocalizedString("deletionAlertCancel", comment: ""),
                          style: .cancel,
                          handler: { _ in })
        ])
    }
}

//MARK: - ProductQuantityView
struct ProductQuantityView: View {
    @EnvironmentObject var dataService: DataService

    @ScaledMetric var symbolSize: CGFloat = 17
    
    @Binding var selectedItems: [ItemModel]
    @Binding var list: ListModel?
    
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
            //master
            let index = selectedItems.firstIndex(where: { $0.product.name == item.name }) ?? 0
            if let list = list {
                let newList = list.removeQuantity(of: selectedItems[index])
                self.list = newList
            }
            if selectedItems[index].quantity! > 1 {
                selectedItems[index].quantity = selectedItems[index].quantity! - 1
            }
            //master

//            let index = selectedItems.firstIndex(where: { $0.product.name == item.name }) ?? 0
//                if let list = list {
//                    let newList = list.removeQuantity(of: selectedItems[index])
//                    self.list = newList
//                }
//                if selectedItems[index].quantity! > 1 {
//                    selectedItems[index].quantity = selectedItems[index].quantity! - 1
//                }
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
                //master
                let index = selectedItems.firstIndex(where: { $0.product.name == item.name }) ?? 0
                if let list = list {
                    let newList = list.addQuantity(of: selectedItems[index])
                    self.list = newList
                }
                selectedItems[index].quantity = (selectedItems[index].quantity ?? 1) + 1
                //master
//                if let index = selectedItems.firstIndex(where: { $0.product.name == item.name }) {
//                    dataService.addQuantity(of: selectedItems[index], from: list)
//                    selectedItems[index].quantity = (selectedItems[index].quantity ?? 1) + 1
//                }
                
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
    
