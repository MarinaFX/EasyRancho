//
//  ListsView.swift
//  Superlista
//
//  Created by Thaís Fernandes on 10/05/21.
//

import SwiftUI

struct ListsView: View {
    @EnvironmentObject var listsViewModel: ListsViewModel
    
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(
                columns: columns,
                spacing: 20,
                content: {
                    ForEach(listsViewModel.list) { list in
                        NavigationLink(destination: ListView(listId: list.id), label: {
                            ZStack {
                                Rectangle()
                                    .fill(Color.orange)
                                    .frame(width: 150, height: 150)
                                    .cornerRadius(15)

                                VStack {
                                    Text(list.title)

                                    HStack {
                                        Image(systemName: list.favorite ? "heart.fill" : "heart")
                                            .onTapGesture {
                                                listsViewModel.toggleListFavorite(of: list)
                                            }

                                        Image(systemName: "minus.circle.fill")
                                            .onTapGesture {
                                                listsViewModel.removeList(list)
                                            }

                                        Text("Editar título")
                                            .onTapGesture {
                                                listsViewModel.editListTitle(of: list, newTitle: "Teste 1")
                                            }
                                    }
                                }
                            }
                        })
                    }
                }
            )
        }
        .padding()
        .navigationBarTitle("Your Lists 📝")
        .navigationBarItems(trailing: Button("Add") {
            listsViewModel.addList(newItem: ListModel(title: "Nova Lista!!!"))
        })
    }
}
