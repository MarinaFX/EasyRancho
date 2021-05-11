//
//  ContentView.swift
//  Superlista
//
//  Created by Marina De Pazzi on 30/04/21.
//

import SwiftUI

struct ProductListView: View {
    let products = ProductListViewModel().products
    
    var body: some View {
        ZStack(alignment: .bottom) {
            List {
                ForEach(products) { item in
                    Text(item.name)
                }
            }
            Button(action: {}, label: {
                Text("top")
            })
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .edgesIgnoringSafeArea(.bottom)
        }
        .navigationTitle("Itens")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProductListView()
        }
    }
}
