//
//  TestView.swift
//  Superlista
//
//  Created by Thaís Fernandes on 06/05/21.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var listsViewModel: ListsViewModel
        
    let listId: String
    
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
            VStack {
                ListHeader(list: getList())
                
                NavigationLink(destination: AddNewItemView(list: getList(), searchText: "")){
                    FakeSearchBar()
                        .padding(.leading, 20)
                }
                
                ListPerItemsView(list: getList())
                
            }
            .padding(.horizontal)
        ))
    }
}
