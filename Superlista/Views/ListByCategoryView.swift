//
//  ListByCategoryView.swift
//  Superlista
//
//  Created by Gabriela Zorzo on 17/05/21.
//

import SwiftUI

struct ListByCategoryView: View {
    @EnvironmentObject var listsViewModel: ListsViewModel
    
    var categoryName: String
    
    var list: ListModel // ?
    
    func rows() -> [ItemModel] { listsViewModel.list.first(where: { $0.id == list.id })!.items[categoryName]! }
    
    
    
    var body: some View {
        MainScreen(customView: AnyView(
            VStack (alignment: .leading){
                
                VStack(alignment: .leading){
                    
                    Text(categoryName).font(.system(size: 24, weight: .bold))
                        .lineLimit(2)
                        .foregroundColor(getColor(category: categoryName))
                    
                    
//                    Rectangle()
//                        .frame(width: 200, height: 1)
//                        .foregroundColor(color1)
                }
                .padding(.leading, 20)
                .padding(.trailing, 10)
                
                
                
                List {
                    ForEach(rows()) { item in
                        ItemCommentView(item: item, list: list)
                    }
                    .onDelete { row in
                        listsViewModel.removeItem(from: row, of: categoryName, of: list)
                    }
                    
                }
            }
            
        ))
    }
}
