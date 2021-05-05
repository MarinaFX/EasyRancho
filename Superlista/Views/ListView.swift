//
//  ListView.swift
//  Superlista
//
//  Created by Thaís Fernandes on 05/05/21.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    let products = ProductListViewModel().products
    
    var body: some View {
        ZStack {
            if listViewModel.list.isEmpty {
                Text("No items")
            } else {
                List {
                    ForEach(listViewModel.list) { item in
                        HStack(alignment: .top) {
                            Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                                .foregroundColor(item.isCompleted ? .green : .red)
                                .onTapGesture {
                                    listViewModel.updateItemCompletion(item: item)
                                }
                            
                            VStack(alignment: .leading) {
                                Text(item.product.name)
                                    .fontWeight(.semibold)
                                
                                if let comment = item.comment {
                                    Text(comment)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Spacer()
                            
                            Image(systemName: "plus.bubble")
                                .foregroundColor(.purple)
                                .onTapGesture {
                                    listViewModel.updateItemComment(item: item, comment: "Comment :)")
                                }
                        }
                    }
                    .onDelete(perform: listViewModel.deleteItem)
                    
                }
            }
        }
        .navigationTitle("Groceries List 📝")
        .navigationBarItems(leading: EditButton(),
                            trailing: Button("Add") {
                                listViewModel.addItem(product: products[0])
                                listViewModel.addItem(product: products[1])
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
