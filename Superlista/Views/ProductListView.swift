//
//  ContentView.swift
//  Superlista
//
//  Created by Marina De Pazzi on 30/04/21.
//

import SwiftUI

struct ProductListView: View {
    let integration = DataModelIntegration.integration

    let products = ProductListViewModel().productsOrdered
    
    var list: ListModel

    @State var selectedItems: [ItemModel] = []
        
    @Binding var filter: String
    
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
                        .foregroundColor(isSelected(item: item) ? Color("Selected") : Color.primary)
                        
                    Text(item.name)
                        .foregroundColor(isSelected(item: item) ? Color("Selected") : Color.primary)
                        .font(.system(size: 14, weight: isSelected(item: item) ? .bold : .regular))
                    Spacer()
                    Text("                                           ") // gambiarra emergencial
                }
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    if isSelected(item: item),
                       let index = selectedItems.firstIndex(where: { $0.product.name == item.name }) {

                        integration.removeItem(selectedItems[index], from: list)
                        
                        selectedItems.remove(at: index)
                    } else {
                        let newItem = ItemModel(product: item)

                        integration.addItem(newItem, to: list)
                        
                        selectedItems.append(newItem)
                    }
                }
            }
            .listRowBackground(Color("background"))
        }
        .listStyle(PlainListStyle())
    }
}
 
