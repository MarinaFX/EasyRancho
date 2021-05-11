//
//  GridListView.swift
//  Superlista
//
//  Created by Marina De Pazzi on 11/05/21.
//

import SwiftUI

struct GridListView: View {
    @Binding var items: [ItemModel]
    @Binding var currentItem: ItemModel?
    
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 20, content: {
                ForEach(self.items) { item in
                    ZStack {
                        Rectangle()
                            .fill(Color.orange)
                            .frame(width: 150, height: 150)
                            .cornerRadius(15)
                        
                        Text(item.product.name)
                    }
                    .onDrag({
                        self.currentItem = item
                        return NSItemProvider(contentsOf: URL(string: "\(item.id)")!)!
                    })
                    .onDrop(of: [.url], delegate: DropViewDelegate(item: item, items: $items, currentItem: self.currentItem))
                }
            })
        }
        .padding()
        .padding(.top)
    }
}

struct GridListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GridListView(items: .constant([
            ItemModel(id: "5", product: ProductModel(id: 599, name: "Flemis food", category: "Flemis cookie"), comment: "Flemisflemis", isCompleted: true),
            ItemModel(id: "600", product: ProductModel(id: 600, name: "Flemis drink", category: "Flemis drink"), comment: "Flemisflemis", isCompleted: true),
            ItemModel(id: "601", product: ProductModel(id: 601, name: "Flemis veggie", category: "Flemis vegetables"), comment: "Flemisflemis", isCompleted: true),
            ItemModel(id: "602", product: ProductModel(id: 602, name: "Flemis oil", category: "Flemis oils"), comment: "Flemisflemis", isCompleted: true)]), currentItem: .constant(nil))
            
                .navigationTitle("Listas")
        }
    }
}
