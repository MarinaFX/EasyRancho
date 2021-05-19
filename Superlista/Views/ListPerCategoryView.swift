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
    
    var categories: [CategoryModel] { listsViewModel.list.first(where: { $0.id == list.id })!.items.keys.map { $0 } }
    
    func rows(from category: Int) -> [ItemModel] { listsViewModel.list.first(where: { $0.id == list.id })!.items[categories[category]]! }
    
    var body: some View {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 20, content: {
                    ForEach(0..<(list.items.count), id: \.self) { category in
                            ZStack(alignment: .center) {
                                Rectangle()
                                    .fill(getColor(category: categories[category].title))
                                    .frame(width: 150, height: 75)
                                    .cornerRadius(15)
                                    .shadow(radius: 10)
                                
                                Text(categories[category].title)
                                    .bold()
                                    .frame(alignment: .center)
                                    .foregroundColor(.white)
                                
                            }
//                            .onDrag({
//                                listsViewModel.currentCategory = categories[category]
//                                return NSItemProvider(contentsOf: URL(string: "\(category)")!)!
//                            })
//                            .onDrop(of: [.url], delegate: CategoryDropViewDelegate(listsViewModel: listsViewModel, list: list, category: categories[category].title))
                    }
                     
                })
                .padding(.top)
            }
    }
}

//struct CategoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryView()
//    }
//}
