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
    let color1 = Color("Color1")
    
    let list: ListModel?
    @Binding var listId: String?
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                
                ZStack(alignment: .leading) {
                    if canEditTitle {
                        if listaTitulo.isEmpty {
                            Text("Nova Lista")
                                .foregroundColor(color1)
                                .font(.system(size: 24, weight: .bold))

                        }
                        
                        TextField("", text: $listaTitulo)
                            .foregroundColor(.black)
                            .font(.system(size: 24, weight: .bold))
                        
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
                
                Rectangle()
                    .frame(width: 200, height: 1)
                    .foregroundColor(color1)
            }
            
            Spacer()
            
            Image(systemName: "pencil")
                .resizable()
                .frame(width: 22, height: 22)
                .foregroundColor(color1)
                .onTapGesture {
                    if let list = list {
                        if canEditTitle && !listaTitulo.isEmpty {
                            listsViewModel.editListTitle(of: list, newTitle: listaTitulo)
                            canEditTitle = false
                        } else {
                            canEditTitle = true
                        }
                    } else {
                        let newList = ListModel(title: listaTitulo)
                        listsViewModel.addList(newItem: newList)
                        self.listId = newList.id
                        canEditTitle = false
                    }
                }
            
            Spacer()
            
            Image(systemName: "square.grid.2x2.fill")
                .resizable()
                .frame(width: 22, height: 22)
                .foregroundColor(color1)
            
            Spacer()
            
            Image(systemName: (list?.favorite ?? false) ? "heart.fill" : "heart")
                .resizable()
                .frame(width: 22, height: 22)
                .foregroundColor((list?.favorite ?? false) ? .red : Color("Color1"))
                .onTapGesture {
                    if let list = list {
                        isFavorite.toggle()
                        listsViewModel.toggleListFavorite(of: list)
                    }
                }
        }
        .onAppear {
            if let list = list {
                listaTitulo = list.title
                isFavorite = list.favorite
                canEditTitle = false
            }
        }
    }
    
}