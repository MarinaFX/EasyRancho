//
//  TestView.swift
//  Superlista
//
//  Created by Thaís Fernandes on 06/05/21.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var listsViewModel: ListsViewModel

    let products = ProductListViewModel().products
    
    let listId: String
    
    var categories: [String] { listsViewModel.list.first(where: { $0.id == listId })!.items.keys.map { $0 } }

    func rows(from category: Int) -> [ItemModel] { listsViewModel.list.first(where: { $0.id == listId })!.items[categories[category]]! }

    func getList() -> ListModel {
        return listsViewModel.list.first(where: { $0.id == listId })!
    }

    var body: some View {

        List {
            ForEach(0..<(getList().items.count), id: \.self) { category in

                Section(header: Text(categories[category])) {

                    ForEach(rows(from: category)) { item in
                        VStack {
                            HStack {
                                Text(item.isCompleted ? "o" : "oo")
                                    .onTapGesture {
                                        listsViewModel.toggleCompletion(of: item, from: getList())
                                    }
                                Text(item.product.name)
                                Spacer()
                                Text("add comment")
                                    .onTapGesture {
                                        listsViewModel.addComent("teste", to: item, from: getList())
                                    }
                            }

                            if let comment = item.comment {
                                Text(comment)
                            }
                        }
                    }
                    .onDelete { row in
                        listsViewModel.removeItem(from: row, of: categories[category], of: getList())
                    }

                }

            }

        }
        .navigationBarTitle(getList().title)
        .navigationBarItems(trailing: Button("Add") {
            let index = Int.random(in: 0..<products.count)
            listsViewModel.addItem(products[index], to: getList())
        })

    }
}
