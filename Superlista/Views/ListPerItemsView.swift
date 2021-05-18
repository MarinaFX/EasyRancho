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
    
    var categories: [String] { listsViewModel.list.first(where: { $0.id == list.id })!.items.keys.map { $0 } }
    
    func rows(from category: Int) -> [ItemModel] { listsViewModel.list.first(where: { $0.id == list.id })!.items[categories[category]]! }
    
    func isLast(_ item: ItemModel, from category: Int) -> Bool {
        return rows(from: category).last?.id == item.id
    }
    
    var body: some View {
        ZStack {
            Color.white
            
            List {
                ForEach(0..<(list.items.count), id: \.self) { category in
                    
                    Section(header: HStack{
                        Text(categories[category])
                            .font(.headline)
                            .foregroundColor(getColor(category: categories[category]))
                            .padding()
                        
                        Spacer()
                    }
                    .frame(maxHeight: 30)
                    .textCase(nil) // TALVEZ TENHA QUE TIRAR
                    .background(background)
                    .listRowInsets(EdgeInsets(
                                    top: -5,
                                    leading: 0,
                                    bottom: -5,
                                    trailing:0))
                    
                    ) {
                        
                        ForEach(rows(from: category)) { item in
                            
                            ItemCommentView(item: item, list: list)
                                .padding(.bottom, isLast(item, from: category) ? 8 : 0)
                        }
                        .onDelete { row in
                            listsViewModel.removeItem(from: row, of: categories[category], of: list)
                        }
                        
                    }
                    
                }
            }
        }
        .onAppear {
            UITableView.appearance().showsVerticalScrollIndicator = false
        }
    }
}

//struct ListPerItemsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListPerItemsView()
//    }
//}
