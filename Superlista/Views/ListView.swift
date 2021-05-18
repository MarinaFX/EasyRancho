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
    
    var navigationTitle: String {
        return getList() != nil ? "Sua Lista" : "Nova Lista"
    }
    
    func getList() -> ListModel? {
        if let listId = listId,
           let list = listsViewModel.list.first(where: { $0.id == listId }) {
            return list
        }
        
        return nil
    }
    
    var body: some View {
        MainScreen(customView: AnyView(
            VStack {
                ListHeader(list: getList(), listId: $listId)
                    .padding(.horizontal, 30)
                    .padding(.top, 4)
                
                if let list = getList() {
                    NavigationLink(destination: AddNewItemView(list: list, searchText: "")){
                        FakeSearchBar()
                            .padding(.top, 10)
                            .padding(.bottom, 20)
                            .padding(.horizontal, 26)
                    }
                    
                    ListPerItemsView(list: list)
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                } else {
                    Spacer()
                }
            }
        ))

        .toolbar {
            ToolbarItem(placement: .principal) {
               Text(navigationTitle)
                .bold()
                .foregroundColor(.white)
            }
        }
    }
}
