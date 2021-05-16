//
//  ContentView.swift
//  Superlista
//
//  Created by Marina De Pazzi on 30/04/21.
//

import SwiftUI

struct ProductListView: View {
    let products = ProductListViewModel().productsOrdered
    
    @Binding var selectedItems: Array<ProductModel>
    
    @Binding var filter: String
    
    var body: some View {
        
        List {
            ForEach(filter.isEmpty ? products : products.filter({$0.name.contains(filter)})) { item in
                HStack {
                    Image(systemName: selectedItems.contains(item) ? "checkmark" : "plus")
                        .foregroundColor(Color.primary)
                    Text(item.name)
                        .foregroundColor(Color.primary)
                }
                .onTapGesture {
                    if selectedItems.contains(item) {
                        let index = selectedItems.firstIndex(where: {
                            $0 == item
                        })
                        selectedItems.remove(at: index!)
                    }
                    else {
                        selectedItems.append(item)
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
        
        
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        NavigationView {
//            ProductListView(filter: .constant(""))
//        }
//    }
//}
