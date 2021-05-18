//
//  GridListView.swift
//  Superlista
//
//  Created by Marina De Pazzi on 11/05/21.
//

import SwiftUI

struct GridListView: View {
    @EnvironmentObject var listsViewModel: ListsViewModel
    
    @State var isEditing : Bool = false
    
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        VStack{
            HStack{
                Text("Listas")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(Color.primary)
                Spacer()
                Button(action: {isEditing.toggle()}, label: {Text("Edit")})
            }
            .padding(.horizontal)
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 20, content: {
                    ForEach(listsViewModel.list) { list in
                        if isEditing{
                            ZStack(alignment: .bottom) {
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width: 150, height: 150)
                                    .cornerRadius(15)
                                    .shadow(radius: 10)
                                
                                Text(list.title)
                                    .frame(alignment: .bottom)
                                    .padding(.bottom)
                                
                                Image(systemName: list.favorite ? "heart.fill" : "heart")
                                    .foregroundColor(list.favorite ? Color.red : Color.black)
                                    .position(x: 150, y: 22)
                                    .onTapGesture {
                                        listsViewModel.toggleListFavorite(of: list)
                                    }
                                
                                //                                                Image(systemName: "minus.circle.fill")
                                //                                                    .font(.title)
                                //                                                    .foregroundColor(Color(.systemGray))
                                //                                                    .offset(x: -75, y: -135)
                            }
                            .overlay(
                                Image(systemName: "minus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(Color(.systemGray))
                                    .offset(x: -80, y: -80)
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
                            ZStack(alignment: .bottom) {
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width: 150, height: 150)
                                    .cornerRadius(15)
                                    .shadow(radius: 10)
                                
                                Text(list.title)
                                    .frame(alignment: .bottom)
                                    .padding(.bottom)
                                
                                Image(systemName: list.favorite ? "heart.fill" : "heart")
                                    .foregroundColor(list.favorite ? Color.red : Color.black)
                                    .position(x: 145, y: 22)
                                    .onTapGesture {
                                        listsViewModel.toggleListFavorite(of: list)
                                    }
                                
                                //                                                Image(systemName: "minus.circle.fill")
                                //                                                    .font(.title)
                                //                                                    .foregroundColor(Color(.systemGray))
                                //                                                    .offset(x: -75, y: -135)
                            }
                        }
                    }
                    
                })
                .padding(.top)
            }
        }
        .padding()
        //.padding(.top)
        
        //        .toolbar{
        //            ToolbarItem(placement: .destructiveAction){
        //                Button(action: {isEditing.toggle()}, label: {Text("Edit")})
        //            }
        //        }
        //        .navigationTitle("Listas")
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
