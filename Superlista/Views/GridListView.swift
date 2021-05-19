//
//  GridListView.swift
//  Superlista
//
//  Created by Marina De Pazzi on 11/05/21.
//

import SwiftUI
import UIKit

struct GridListView: View {
    
//    init() {
//            //Use this if NavigationBarTitle is with displayMode = .inline
//        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "San-Francisco", size: 36)!]
//        }
    
    @EnvironmentObject var listsViewModel: ListsViewModel
    
    @State var isEditing : Bool = false
    
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        ZStack{
//            Color("HeaderColor")
//                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 20, content: {
                    ForEach(listsViewModel.list) { list in
                        if isEditing{
                            ZStack(alignment: .bottom) {
                                Rectangle()
                                    .fill(Color("HeaderColor"))
                                    .frame(width: 160, height: 75)
                                    .cornerRadius(15)
                                    .shadow(color: Color("Shadow"), radius: 5)
                                
                                Text(list.title)
                                    .bold()
                                    .foregroundColor(Color.white)
                                    .frame(alignment: .center)
                                    .padding(.bottom)
                                
                                Image(systemName: list.favorite ? "heart.fill" : "heart")
                                    .foregroundColor(list.favorite ? Color("Favorite") : Color.white)
                                    .position(x: 150, y: 22)
                                    .onTapGesture {
                                        listsViewModel.toggleListFavorite(of: list)
                                    }
                                
                            }
                            .overlay(
                                Image(systemName: "minus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(Color(.systemGray))
                                    .offset(x: -70, y: -70)
                                    .onTapGesture {
                                        listsViewModel.removeList(list)
                                    }
                            )
                            
                            
                            .onDrag({
                                listsViewModel.currentList = list
                                return NSItemProvider(contentsOf: URL(string: "\(list.id)")!)!
                            })
                            .onDrop(of: [.url], delegate: DropViewDelegate(listsViewModel: listsViewModel, list: list))
                            
                        }
                        
                        else {
                            NavigationLink(destination: ListView(listId: list.id), label: {
                                ZStack(alignment: .bottom) {
                                    Rectangle()
                                        .fill(Color("HeaderColor"))
                                        .frame(width: 160, height: 75)
                                        .cornerRadius(15)
                                        .shadow(color: Color("Shadow"), radius: 5)
                                    
                                    Text(list.title)
                                        .bold()
                                        
                                        .foregroundColor(Color.white)
                                        .frame(alignment: .center)
                                        .padding(.bottom)
                                    
                                    Image(systemName: list.favorite ? "heart.fill" : "heart")
                                        .foregroundColor(list.favorite ? Color("Favorite") : Color.white)
                                        .position(x: 145, y: 22)
                                        .onTapGesture {
                                            listsViewModel.toggleListFavorite(of: list)
                                        }
                                }
                            })
                        }
                    }
                     
                })
                .padding(.top)
            }
            .padding(.horizontal)
        
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading){
                        Button(action: {isEditing.toggle()}, label: {
                                Text(isEditing ? "Concluir": "Editar")})
                    }
                    ToolbarItem(placement: .principal){
                        Text("Listas").font(.system(size: 36, weight: .bold)).foregroundColor(Color.primary)
                    }
                    ToolbarItem(placement: .destructiveAction){
                        Button(action: {listsViewModel.addList(newItem: ListModel(title: "Nova Lista"))}, label: {Text("Nova lista")})
                    }
                } 
    }
    }
}

struct GridListView_Previews: PreviewProvider {
    static var listsViewModel: ListsViewModel = ListsViewModel()
    static var previews: some View {
        NavigationView {
            GridListView()
                
                .navigationTitle("Listas")
        }
        .environmentObject(listsViewModel)
    }
}
