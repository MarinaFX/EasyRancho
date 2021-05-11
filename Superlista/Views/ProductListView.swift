//
//  ContentView.swift
//  Superlista
//
//  Created by Marina De Pazzi on 30/04/21.
//

import SwiftUI

struct ProductListView: View {
    let products = ProductListViewModel().products
    
    @State var selectedItems: Set<String> = []
    
    @Binding var filter: String
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                List {
                    ForEach(filter.isEmpty ? products : products.filter({$0.name.contains(filter)})) { item in
                        HStack {
                            Image(systemName: selectedItems.contains(item.name) ? "checkmark" : "plus")
                            Text(item.name)
                        }
                        .onTapGesture {
                            if selectedItems.contains(item.name) {
                                selectedItems.remove(item.name)
                            }
                            else {
                                selectedItems.insert(item.name)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {

        NavigationView {
            ProductListView(filter: .constant(""))
        }
    }
}
