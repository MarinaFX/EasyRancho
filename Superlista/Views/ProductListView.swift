//
//  ContentView.swift
//  Superlista
//
//  Created by Marina De Pazzi on 30/04/21.
//

import SwiftUI

struct ProductListView: View {
    @EnvironmentObject var listsViewModel: ListsViewModel
    
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
                        .foregroundColor(Color.primary)
                    
                    Text(item.name)
                        .foregroundColor(Color.primary)
                }
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
                }
            }
            .listRowBackground(Color("background"))
        }
        .listStyle(PlainListStyle())
    }
}
 
