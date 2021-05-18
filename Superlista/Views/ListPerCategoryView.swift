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
    
    var categories: [String] { listsViewModel.list.first(where: { $0.id == list.id })!.items.keys.map { $0 } }
    
    func rows(from category: Int) -> [ItemModel] { listsViewModel.list.first(where: { $0.id == list.id })!.items[categories[category]]! }
    
    var body: some View {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 20, content: {
                    ForEach(0..<(list.items.count), id: \.self) { category in
                        
                        NavigationLink(destination: ListByCategoryView(categoryName: categories[category], list: list)){
                            ZStack(alignment: .center) {
                                Rectangle()
                                    .fill(getColor(category: categories[category]))
                                    .frame(width: 160, height: 75)
                                    .cornerRadius(15)
                                    .shadow(color: Color("Shadow"), radius: 5)
                                
                                Text(categories[category])
                                    .bold()
                                    .frame(alignment: .center)
                                    .frame(maxWidth: 150)
                                    .foregroundColor(.white)
                                
                            }
                            .onDrag({
                                listsViewModel.currentList = list
                                return NSItemProvider(contentsOf: URL(string: "\(list.id)")!)!
                            })
                            .onDrop(of: [.url], delegate: DropViewDelegate(listsViewModel: listsViewModel, list: list))
                        }
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
