//
//  GridListView.swift
//  Superlista
//
//  Created by Marina De Pazzi on 11/05/21.
//

import SwiftUI

struct GridListView: View {
    @EnvironmentObject var listsViewModel: ListsViewModel
    
    @State var isEditing: Bool = false
    
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 20, content: {
                ForEach(listsViewModel.list) { list in
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
                        
                        Image(systemName: isEditing ? "minus.circle.fill" : "")
                            .position(x: 30, y: 5)
                            .scaleEffect(1.1)
                            
                    }
                    .onLongPressGesture {
                        isEditing.toggle()
                    }
                    //.background(Color.green)
                    .onDrag({
                        listsViewModel.currentList = list
                        return NSItemProvider(contentsOf: URL(string: "\(list.id)")!)!
                    })
                    .onDrop(of: [.url], delegate: DropViewDelegate(listsViewModel: listsViewModel, list: list))
                }
            })//.background(Color.orange)
            .padding(.top)
        }
        //.background(Color.blue)
        .padding()
        .padding(.top)
        
        .toolbar{
            ToolbarItem(placement: .destructiveAction){
                EditButton()
            }
        }
        .navigationTitle("Listas")
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
