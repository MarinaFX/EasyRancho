//
//  ContentView.swift
//  Superlista
//
//  Created by Marina De Pazzi on 30/04/21.
//

import SwiftUI

struct ProductListView: View {
    @EnvironmentObject var listsViewModel: ListsViewModel
    
    var list: ListModel
    
    let products = ProductListViewModel().productsOrdered
    
    var categories: [CategoryModel] { listsViewModel.list.first(where: { $0.id == list.id })!.items.keys.map { $0 } }
    
    func rows(from category: Int) -> [ItemModel] { listsViewModel.list.first(where: { $0.id == list.id })!.items[categories[category]]! }
    
    // @Binding var selectedItems: Array<ProductModel>
    
    @State var isSelected: Bool = false
    
    @Binding var filter: String
    
    var body: some View {
        List {
            ForEach(filter.isEmpty ? products : products.filter({$0.name.contains(filter)})) { item in
                HStack {
                    Image(systemName: isSelected ? "checkmark" : "plus")
                        .foregroundColor(Color.primary)
                    
                    Text(item.name)
                        .foregroundColor(Color.primary)
                }
                .onTapGesture {
                    if isSelected {
                        listsViewModel.addItem(item, to: list)
                    } else {
                        listsViewModel.removeItem(from: rows(from: categories), of: categories, of: list)
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
    }
}
 
