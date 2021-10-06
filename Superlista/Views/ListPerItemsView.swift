//
//  ListPerItemsView.swift
//  Superlista
//
//  Created by Gabriela Zorzo on 12/05/21.
//

import SwiftUI

struct ListPerItemsView: View {
    
    @EnvironmentObject var listsViewModel: ListsViewModel
    
    var list: ListModel
    
    let background = Color("background")
    
    var categories: [CategoryModel] { listsViewModel.list.first(where: { $0.id == list.id })!.items.keys.map { $0 } }
    
    func rows(from category: Int) -> [ItemModel] { listsViewModel.list.first(where: { $0.id == list.id })!.items[categories[category]]! }
    
    func isLast(_ item: ItemModel, from category: CategoryModel) -> Bool {
        return getRows(from: category).last?.id == item.id
    }
    
    func getCategories() -> [CategoryModel] {
        return Array(list.items.keys.map { $0 }).sorted(by: { $0.order ?? 0 < $1.order ?? 0 })
    }
    
    func getRows(from category: CategoryModel) -> [ItemModel] {
        return list.items[category] ?? []
    }
    
    var body: some View {
        List {
            ForEach(getCategories(), id: \.self) { category in
                
                Section(header: HStack {
                    Text(category.title)
                        .font(.headline)
                        .foregroundColor(getColor(category: category.title))
                        .padding()
                    
                    Spacer()
                }
                .frame(maxHeight: 30)
                .textCase(nil) // TALVEZ TENHA QUE TIRAR
                .background(Color("background"))
                .listRowInsets(EdgeInsets(
                    top: 0,
                    leading: 0,
                    bottom: -5,
                    trailing: 0))
                        
                ) {
                    
                    ForEach(getRows(from: category)) { item in
                        
                        ItemCommentView(item: item, list: list)
                            .padding(.bottom, isLast(item, from: category) ? 8 : 0)
                    }
                    .onDelete { row in
                        listsViewModel.removeItem(from: row, of: category, of: list)
                    }
                    .listRowBackground(Color("background"))
                }
                
            }
            .listRowBackground(Color("background"))
            
        }
        .listStyle(PlainListStyle())
        .onAppear {
            UITableView.appearance().showsVerticalScrollIndicator = false

        }
    }
}
