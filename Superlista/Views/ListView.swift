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
    @State var list: ListModel?
    @State var listTitle: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            MainScreen(customView: AnyView(
                ZStack {
                    // MARK: - background color
                    Color("background")
                        .ignoresSafeArea()
                    
                    VStack (spacing: 20) {
                        // MARK: - header
                        ListHeader(listaTitulo: $listTitle, canEditTitle: $canEditTitle, list: self.list, listId: $listId)
                        
                        if let list = self.list {
                            
                            // MARK: - search bar
                            NavigationLink(destination: AddNewItemView(list: list, searchText: "")){
                                FakeSearchBar()
                                    .padding(.horizontal, 20)
                            }
                            
                            // MARK: - list component
                            ListPerItemsView(list: list)
                                .padding(.horizontal)
                                .padding(.bottom, 30)
                            
                        } else {
                            Spacer()
                        }
                    }
                }
            ), topPadding: -30)
            
            // MARK: - toolbar
                .toolbar{
                    
                    // MARK: - edit button
                    ToolbarItem {
                        Button {
                            editTitle()
                        } label: {
                            Text(canEditTitle ? "Salvar" : "Editar")
                        }
                    }
                }
            // MARK: - onAppear
                .onAppear {
                    self.list = getList()
                }
        }
    }
    
    // MARK: - getList()
    func getList() -> ListModel? {
        if let listId = listId,
           let list = listsViewModel.list.first(where: { $0.id == listId }) {
            return list
        }
        return nil
    }
    
    // MARK: - editList()
    func editTitle() {
        if let unwrappedList = self.list {
            if canEditTitle && !listTitle.isEmpty {
                listsViewModel.editListTitle(of: unwrappedList, newTitle: listTitle)
                canEditTitle = false
            } else {
                canEditTitle = true
            }
        }
    }
}

