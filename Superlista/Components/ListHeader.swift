//
//  ListHeader.swift
//  Superlista
//
//  Created by Thaís Fernandes on 17/05/21.
//

import SwiftUI

struct ListHeader: View {
    @EnvironmentObject var listsViewModel: ListsViewModel
    
    @State var listaTitulo: String = ""
    @State var canComment: Bool = false
    @State var comentario: String = ""
    @State var canEditTitle: Bool = true
    @State var isFavorite: Bool = false
    
    let purpleColor = Color("HeaderColor")
    let secondary = Color("Secondary")
    let list: ListModel?
    
    @Binding var listId: String?
    
    var body: some View {
        HStack (spacing: 5){
            VStack(alignment: .leading){
                
                ZStack(alignment: .leading) {
                    if canEditTitle {
                        if listaTitulo.isEmpty {
                            Text("Nova Lista")
                                .foregroundColor(secondary)
                                .font(.system(size: 24, weight: .bold))
                            
                        }
                        
                        TextField("", text: $listaTitulo)
                            .foregroundColor(canEditTitle ? Color("background") : .black)
                            .font(.system(size: 24, weight: .bold))
                            .background(Color("editTitleBackground"))
                        
                    }
                    
                    if !canEditTitle, let list = list {
                        HStack {
                            Text(list.title).font(.system(size: 24, weight: .bold))
                                .lineLimit(2)
                                .foregroundColor(Color.primary)
                            Spacer()
                        }
                        
                    }
                }
                .frame(maxWidth: .infinity)
                
//                Rectangle()
//                    .frame(width: 200, height: 1)
//                    .foregroundColor(secondary)
            }
            
            Spacer()
            
            Image(systemName: "pencil")
                .resizable()
                .frame(width: 22, height: 22)
                .foregroundColor(canEditTitle ? .gray : secondary)
                .onTapGesture {
                    if let unwrappedList = list {
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
                }
            
            Spacer()
            
            Image(systemName: listsViewModel.isGrid ? "list.bullet" : "square.grid.2x2.fill")
                    .resizable()
                    .frame(width: 22, height: 22)
                    .foregroundColor(secondary)
                .onTapGesture {
                    listsViewModel.isGrid.toggle()
                }
            
            Spacer()
            
            Image(systemName: (list?.favorite ?? false) ? "heart.fill" : "heart")
                .resizable()
                .frame(width: 22, height: 22)
                .foregroundColor((list?.favorite ?? false) ? Color("Favorite") : Color("Secondary"))
                .onTapGesture {
                    if let list = list {
                        isFavorite.toggle()
                        listsViewModel.toggleListFavorite(of: list)
                    }
                }
        }
        .padding(.horizontal, 30)
        .onAppear {
            if let list = list {
                listaTitulo = list.title
                isFavorite = list.favorite
                canEditTitle = false
            }
            
        }
    }
    
}
