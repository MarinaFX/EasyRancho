//
//  ListHeader.swift
//  Superlista
//
//  Created by Thaís Fernandes on 17/05/21.
//

import SwiftUI

struct ListHeader: View {
    let integration = DataModelIntegration.integration
    
    @Binding var listaTitulo: String
    @State var canComment: Bool = false
    @State var comentario: String = ""
    @Binding var canEditTitle: Bool
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
                            .onTapGesture {
                                if listaTitulo == "Nova Lista"{
                                    listaTitulo = ""
                                }
                            }
                        
                        
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
                
            }
            
            Spacer()
            
            
            Spacer()
            
            Image(systemName: integration.listsViewModel.isGrid ? "list.bullet" : "square.grid.2x2.fill")
                .resizable()
                .frame(width: 22, height: 22)
                .foregroundColor(secondary)
                .onTapGesture {
                    integration.listsViewModel.isGrid.toggle()
                }
            
            Spacer()
            
            Image(systemName: (list?.favorite ?? false) ? "heart.fill" : "heart")
                .resizable()
                .frame(width: 25, height: 22)
                .foregroundColor((list?.favorite ?? false) ? Color("Favorite") : Color("Secondary"))
                .onTapGesture {
                    if let list = list {
                        isFavorite.toggle()
                        #warning("toggleListFav")
                        integration.listsViewModel.toggleListFavorite(of: list)
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


