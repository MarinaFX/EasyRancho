//
//  TestView.swift
//  Superlista
//
//  Created by Thaís Fernandes on 06/05/21.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var listsViewModel: ListsViewModel
    
    @State var listId: String?
    @State var canEditTitle: Bool = false
    @State var isFavorite: Bool = false
    
    func getList() -> ListModel? {
        if let listId = listId,
           let list = listsViewModel.list.first(where: { $0.id == listId }) {
            return list
        }
        return nil
    }
    
    @State var listaTitulo: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            MainScreen(customView: AnyView(
                ZStack{
                    Color("background")
                        .ignoresSafeArea()
                    
                    VStack (spacing: 20) {
                        ListHeader(listaTitulo: $listaTitulo, canEditTitle: $canEditTitle, list: getList(), listId: $listId)
                        
                        if let list = getList() {
                            NavigationLink(destination: AddNewItemView(list: list, searchText: "")){
                                FakeSearchBar()
                                    .padding(.horizontal, 20)
                            }
                            
                            ListPerItemsView(list: list)
                                .padding(.horizontal)
                                .padding(.bottom, 30)
                            
                        } else {
                            Spacer()
                        }
                    }
                }
            ), topPadding: -30)
            .toolbar{
                ToolbarItem{
                    Button {
                        if let unwrappedList = getList() {
                            if canEditTitle && !listaTitulo.isEmpty {
                                listsViewModel.editListTitle(of: unwrappedList, newTitle: listaTitulo)
                                canEditTitle = false
                            } else {
                                canEditTitle = true
                            }
                        }
                        else {
                            let newList = ListModel(title: listaTitulo)
                            listsViewModel.addList(newItem: newList)
                            self.listId = newList.id
                            canEditTitle = false
                        }
                        
                    } label: {
                        Text(canEditTitle ? "Salvar" : "Editar")
                    }
                }
            }
        }
    }
}
 
