//
//  CategoryView.swift
//  Superlista
//
//  Created by Gabriela Zorzo on 18/05/21.
//

import SwiftUI

struct ListPerCategoryView: View {
    @EnvironmentObject var listsViewModel: ListsViewModel
    
    @State var isEditing : Bool = false
    
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    var list: ListModel
    
    // let background = Color("background") // DEPOIS PRO DARK MODE
    
    func getCategories() -> [CategoryModel] {
        return Array(list.items.keys.map { $0 }).sorted(by: { $0.order ?? 0 < $1.order ?? 0 })
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 20, content: {
                ForEach(getCategories(), id: \.self) { category in
                    ZStack(alignment: .center) {
                        NavigationLink(destination: ListByCategoryView(categoryName: category, list: list)) {
                            Rectangle()
                                .fill(getColor(category: category.title))
                                .frame(width: 160, height: 75)
                                .cornerRadius(15)
                                .shadow(color: Color("Shadow"), radius: 5)
                        }
                        
                        Text(category.title)
                            .bold()
                            .frame(alignment: .center)
                            .frame(maxWidth: 150)
                            .foregroundColor(.white)
                        
                    }
                    .onDrag({
                        listsViewModel.currentCategory = category
                        return NSItemProvider(contentsOf: URL(string: "\(category.id)")!)!
                    })
                    .onDrop(of: [.url], delegate: CategoryDropViewDelegate(listsViewModel: listsViewModel, list: list, category: category))
                }
                
            })
            .padding(.top)
        }
    }
}
