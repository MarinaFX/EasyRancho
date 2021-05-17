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

    let list: ListModel
    
    var body: some View {
        HStack{
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
                    if canEditTitle && !listaTitulo.isEmpty{
                        listsViewModel.editListTitle(of: list, newTitle: listaTitulo)
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
            
            if !list.favorite{
                Image(systemName: "heart")
                    .resizable()
                    .frame(width: 22, height: 22)
                    .foregroundColor(color1)
                    .onTapGesture {
                        isFavorite = true
                        listsViewModel.toggleListFavorite(of: list)
                    }
            } else {
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: 22, height: 22)
                    .foregroundColor(.red)
                    .onTapGesture {
                        isFavorite = true
                        listsViewModel.toggleListFavorite(of: list)
                    }
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 10)
        .onAppear {
            listaTitulo = list.title
            isFavorite = list.favorite
            canEditTitle = false
        }
    }
    
}

//struct ListHeader_Previews: PreviewProvider {
//    static var previews: some View {
//        ListHeader()
//    }
//}
