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
        VStack {
//            List {
//                ForEach(products) { item in
//                    Text(item.name)
//                }
//            }
            
            NavigationLink(
                destination: AddNewItemView(text: ""),
                label: {
                    Text("Navigate")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(height: 40)
                        .frame(width: 165)
                        .background(Color.orange)
                        .cornerRadius(30)
                        .shadow(radius: 10)
                })
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
