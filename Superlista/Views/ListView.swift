//
//  TestView.swift
//  Superlista
//
//  Created by Thaís Fernandes on 06/05/21.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    let products = ProductListViewModel().products
    
    var body: some View {
        List {
            ForEach(0..<listViewModel.categories.count, id: \.self) { category in
                
                Section(header: Text(listViewModel.categories[category])) {
                    
                    ForEach(listViewModel.rows(from: category)) { item in
                        
                        HStack {
                            Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                                .onTapGesture {
                                    listViewModel.toggleCompletion(of: item, from: category)
                                }
                            
                            Text(item.product.name)
                            
                            Image(systemName: "plus.bubble")
                                .onTapGesture {
                                    listViewModel.addComment("teste", to: item, from: category)
                                }
                            
                            if let comment = item.comment {
                                Text(comment)
                            }
                        }
                        
                    }.onDelete { row in
                        listViewModel.deleteItem(from: row, of: category)
                    }
                }
            }
        }
        .navigationBarTitle("Groceries List 📝")
        .navigationBarItems(leading: EditButton(),
                            trailing: Button("Add") {
                                let index = Int.random(in: 0..<products.count)
                                listViewModel.addItem(product: products[index])
                            }
        )
        
    }
    
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListView()
        }.environmentObject(ListViewModel())
    }
}
