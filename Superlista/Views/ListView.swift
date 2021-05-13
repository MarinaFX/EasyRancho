//
//  TestView.swift
//  Superlista
//
//  Created by Thaís Fernandes on 06/05/21.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var listsViewModel: ListsViewModel
    
    let products = ProductListViewModel().productsOrdered
    
    let listId: String
    
    var categories: [String] { listsViewModel.list.first(where: { $0.id == listId })!.items.keys.map { $0 } }
    
    func rows(from category: Int) -> [ItemModel] { listsViewModel.list.first(where: { $0.id == listId })!.items[categories[category]]! }
    
    func getList() -> ListModel {
        return listsViewModel.list.first(where: { $0.id == listId })!
    }
    
    @State var listaTitulo: String = ""
    
    @State var canComment: Bool = false
    @State var comentario: String = ""
    @State var canEditTitle: Bool = true
    
    let purpleColor = Color("HeaderColor")
    let color1 = Color("Color1")
    
    
    
    var body: some View {
        MainScreen(customView: AnyView(
            VStack {
                
                HStack{
                    VStack(alignment: .leading){
                        
                        ZStack(alignment: .leading) {
                            if canEditTitle{
                                if listaTitulo.isEmpty {
                                    Text("Nova Lista")
                                        .foregroundColor(color1)
                                        .font(.system(size: 24, weight: .bold)) }

                                TextField("", text: $listaTitulo)
                                    .foregroundColor(.black)
                                    .font(.system(size: 24, weight: .bold))
                                    
                            }
                            
                            if !canEditTitle {
                                HStack(){
                                    Text(getList().title).font(.system(size: 24, weight: .bold))
                                        .lineLimit(2)
                                    Spacer()
                                }
                                
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        Rectangle()
                            .frame(width: 200, height: 1)
                            .foregroundColor(color1)
                    }
                    
                    
                    Image(systemName: "pencil")
                        .foregroundColor(.gray)
                        .onTapGesture {
                            if canEditTitle && !listaTitulo.isEmpty{
                                listsViewModel.editListTitle(of: getList(), newTitle: listaTitulo)
                                canEditTitle = false
                            } else {
                                canEditTitle = true
                            }
                        }
                    
                    Image(systemName: "square.grid.2x2.fill")
                        .foregroundColor(color1)
                    
                    Image(systemName: "heart")
                        .foregroundColor(color1)
                }
                .padding(.leading, 20)
                .padding(.trailing, 10)
                
                NavigationLink(destination: AddNewItemView(list: getList(), searchText: "")){
                    FakeSearchBar()
                        .padding(.leading, 20)
                }
                
                ListPerItemsView(list: getList())
                    
            }
            .padding(.horizontal)
            .onAppear(){
                listaTitulo = getList().title
            }
        ))
    }
}
