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
            // VStack (spacing: 20) {
                
            //     HStack(spacing: 5){
            //         VStack(alignment: .leading){
                        
            //             ZStack(alignment: .leading) {
            //                 if canEditTitle{
            //                     if listaTitulo.isEmpty {
            //                         Text("Nova Lista")
            //                             .foregroundColor(color1)
            //                             .font(.system(size: 24, weight: .bold)) }
                                
            //                     TextField("", text: $listaTitulo)
            //                         .foregroundColor(color1)
            //                         .font(.system(size: 24, weight: .bold))
                                
            //                 }
                            
            //                 if !canEditTitle {
            //                     HStack(){
            //                         Text(getList().title).font(.system(size: 24, weight: .bold))
            //                             .lineLimit(2)
            //                             .foregroundColor(Color.primary)
            //                         Spacer()
            //                     }
                                
            //                 }
            //             }
            //             .frame(maxWidth: .infinity)
                        
            //             Rectangle()
            //                 .frame(width: 200, height: 1)
            //                 .foregroundColor(color1)
                    }
                    
                    ListPerItemsView(list: list)
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                } else {
                    Spacer()
                    
                    
                //     Image(systemName: "pencil")
                //         .resizable()
                //         .frame(width: 22, height: 22)
                //         .foregroundColor(canEditTitle ? .gray : color1)
                //         .onTapGesture {
                //             if canEditTitle && !listaTitulo.isEmpty{
                //                 listsViewModel.editListTitle(of: getList(), newTitle: listaTitulo)
                //                 canEditTitle = false
                //             } else {
                //                 canEditTitle = true
                //             }
                //         }
                    
                //     Spacer()
                    
                //         Image(systemName: "square.grid.2x2.fill")
                //             .resizable()
                //             .frame(width: 22, height: 22)
                //             .foregroundColor(color1)
                
                    
                //     Spacer()
                    
                //     if !getList().favorite{
                //         Image(systemName: "heart")
                //             .resizable()
                //             .frame(width: 22, height: 22)
                //             .foregroundColor(color1)
                //             .onTapGesture {
                //                 isFavorite = true
                //                 listsViewModel.toggleListFavorite(of: getList())
                //             }
                //     } else {
                //         Image(systemName: "heart.fill")
                //             .resizable()
                //             .frame(width: 22, height: 22)
                //             .foregroundColor(.red)
                //             .onTapGesture {
                //                 isFavorite = true
                //                 listsViewModel.toggleListFavorite(of: getList())
                //             }
                //     }
                // }
                // .padding(.leading, 20)
                // .padding(.trailing, 10)
                
                // NavigationLink(destination: AddNewItemView(list: getList(), searchText: "")){
                //     FakeSearchBar()
                //         .padding(.leading, 20)
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
