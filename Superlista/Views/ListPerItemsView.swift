//
//  ListPerItemsView.swift
//  Superlista
//
//  Created by Gabriela Zorzo on 12/05/21.
//

import SwiftUI

struct ListPerItemsView: View {
    
    @EnvironmentObject var listsViewModel: ListsViewModel
    let products = ProductListViewModel().productsOrdered
    
    var list: ListModel
    
    let background = Color("background")
    
    var categories: [String] { listsViewModel.list.first(where: { $0.id == list.id })!.items.keys.map { $0 } }
    
    func rows(from category: Int) -> [ItemModel] { listsViewModel.list.first(where: { $0.id == list.id })!.items[categories[category]]! }
        
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
                        }
                        .onDelete { row in
                            listsViewModel.removeItem(from: row, of: categories[category], of: list)
                        }
                        
                    }
                    
                }
                
            }
        }
    }
}

//struct ListPerItemsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListPerItemsView()
//    }
//}
