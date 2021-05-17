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
    @State var isFavorite: Bool = false
    
    let purpleColor = Color("HeaderColor")
    let color1 = Color("Color1")
    
    
    
    var body: some View {
        MainScreen(customView: AnyView(
            VStack (spacing: 20) {
                
                HStack(spacing: 5){
                    VStack(alignment: .leading){
                        
                        ZStack(alignment: .leading) {
                            if canEditTitle{
                                if listaTitulo.isEmpty {
                                    Text("Nova Lista")
                                        .foregroundColor(color1)
                                        .font(.system(size: 24, weight: .bold)) }
                                
                                TextField("", text: $listaTitulo)
                                    .foregroundColor(color1)
                                    .font(.system(size: 24, weight: .bold))
                                
                            }
                            
                            if !canEditTitle {
                                HStack(){
                                    Text(getList().title).font(.system(size: 24, weight: .bold))
                                        .lineLimit(2)
                                        .foregroundColor(Color.primary)
                                    Spacer()
                                }
                                
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        Rectangle()
                            .frame(width: 200, height: 1)
                            .foregroundColor(color1)
                    }
                    
                    Spacer()
                    
                    
                    Image(systemName: "pencil")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundColor(canEditTitle ? .gray : color1)
                        .onTapGesture {
                            if canEditTitle && !listaTitulo.isEmpty{
                                listsViewModel.editListTitle(of: getList(), newTitle: listaTitulo)
                                canEditTitle = false
                            } else {
                                canEditTitle = true
                            }
                        }
                    
                    Spacer()
                    
                        Image(systemName: "square.grid.2x2.fill")
                            .resizable()
                            .frame(width: 22, height: 22)
                            .foregroundColor(color1)
                
                    
                    Spacer()
                    
                    if !getList().favorite{
                        Image(systemName: "heart")
                            .resizable()
                            .frame(width: 22, height: 22)
                            .foregroundColor(color1)
                            .onTapGesture {
                                isFavorite = true
                                listsViewModel.toggleListFavorite(of: getList())
                            }
                    } else {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .frame(width: 22, height: 22)
                            .foregroundColor(.red)
                            .onTapGesture {
                                isFavorite = true
                                listsViewModel.toggleListFavorite(of: getList())
                            }
                    }
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
                isFavorite = getList().favorite
                canEditTitle = false
            }
        ))
    }
}
