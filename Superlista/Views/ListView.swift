//
//  TestView.swift
//  Superlista
//
//  Created by Thaís Fernandes on 06/05/21.
//

import SwiftUI

struct ListView: View {
    let integration = DataModelIntegration.integration

    @State var listId: String?
    @State var canEditTitle: Bool = false
    @State var isFavorite: Bool = false
    @State var listTitle: String = ""

    func getList() -> ListModel? {
        if let listId = listId,
           let list = integration.listsViewModel.list.first(where: { $0.id == listId }) {
            return list
        }
        return nil
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            MainScreen(customView: AnyView(
                ZStack{
                    Color("background")
                        .ignoresSafeArea()
                    
                    VStack (spacing: 20) {
                        ListHeader(listaTitulo: $listTitle, canEditTitle: $canEditTitle, list: getList(), listId: $listId)
                        
                        if let list = getList() {
                            NavigationLink(destination: AddNewItemView(list: list, searchText: "")){
                                FakeSearchBar()
                                    .padding(.horizontal, 20)
                            }
                            
                            if !integration.listsViewModel.isGrid {
                                ListPerItemsView(list: list)
                                    .padding(.horizontal)
                                    .padding(.bottom, 30)
                            } else {
                                ListPerCategoryView(list: list)
                                    .padding(.horizontal)
                                    .padding(.bottom, 30)
                            }
                            
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
                            if canEditTitle && !listTitle.isEmpty {
                                
                                integration.updateListTitle(unwrappedList, listTitle)
                                
                                canEditTitle = false
                                
                            } else {
                                canEditTitle = true
                            }
                        }
                        else {
                            let newList = ListModel(title: listTitle)
                            
                            integration.createList(newList)
                            
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
 
