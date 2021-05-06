//
//  ContentView.swift
//  Superlista
//
//  Created by Marina De Pazzi on 30/04/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var productListViewModel: ProductListViewModel
    
    var body: some View {
        VStack {
            List {
                ForEach(productListViewModel.products) { item in
                    Text(item.name)
                }
            }
        }
        .navigationTitle("Itens")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
        .environmentObject(ProductListViewModel())
    }
}
