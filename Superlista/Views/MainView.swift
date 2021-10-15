//
//  GridListView.swift
//  Superlista
//
//  Created by Marina De Pazzi on 11/05/21.
//

import SwiftUI
import UIKit

struct MainView: View {
    let integration = DataModelIntegration.integration
    
    @State var isEditing : Bool = false
    @State var listId: String = ""
    @State var isCreatingList: Bool = false
    
    @State var showAlert = false
    
    var lists: [ListModel] {
        return integration.listsViewModel.list
    }
    
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                NavigationLink(destination: ListView(listId: listId),
                               isActive: $isCreatingList,
                               label: {
                    EmptyView()
                })
                .opacity(0.0)
                
                Color("background")
                    .ignoresSafeArea()
                
                if lists.isEmpty {
                    VStack {
                        Text("Você não tem nenhuma lista!\nQue tal adicionar uma nova lista?")
                            .multilineTextAlignment(.center)
                            .font(.headline)
                        
                        NoItemsView()
                            .frame(width: 400, height: 400)
                    }
                    .onAppear {
                        if lists.isEmpty {
                            self.isEditing = false
                        }
                    }
                }
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 20, content: {
                        ForEach(lists) { list in
                            
                            if isEditing {
                                ZStack(alignment: .bottom) {
                                    Rectangle()
                                        .fill(Color("HeaderColor"))
                                        .frame(width: 160, height: 75)
                                        .cornerRadius(15)
                                        .shadow(color: Color("Shadow"), radius: 10)
                                    
                                    Text(list.title)
                                        .bold()
                                        .foregroundColor(Color.white)
                                        .frame(alignment: .center)
                                        .lineLimit(1)
                                        .padding(.bottom)
                                        .padding(.horizontal)
                                    
                                    Image(systemName: list.favorite ? "heart.fill" : "heart")
                                        .foregroundColor(list.favorite ? Color("Favorite") : Color.white)
                                        .position(x: 150, y: 22)
                                        .onTapGesture {
                                            #warning("Revisar toggleListFavorite")
                                            integration.listsViewModel.toggleListFavorite(of: list)
                                        }
                                    
                                    Image(systemName: "minus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(Color(.systemGray))
                                        .offset(x: -75, y: -60)
                                        .onTapGesture {
                                            integration.listsViewModel.currentList = list
                                            showAlert = true
                                        }
                                }
                                .alert(isPresented: $showAlert){
                                    let listName = String(describing: integration.listsViewModel.currentList?.title)
                                    
                                    return Alert(title: Text("Deseja remover a lista \(listName)?"), message: Text("A lista removida não poderá ser recuperada após sua exclusão"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Apagar"), action: {
                                        
                                        if let currentList = integration.listsViewModel.currentList {
                                            integration.deleteList(currentList)
                                        }
                                        
                                        showAlert = false
                                    }))
                                }
                                .onDrag({
                                    integration.listsViewModel.currentList = list
                                    return NSItemProvider(contentsOf: URL(string: "\(list.id)")!)!
                                })
                                .onDrop(of: [.url], delegate: ListDropViewDelegate(listsViewModel: integration.listsViewModel, list: list))
                            }
                            
                            else {
                                NavigationLink(destination: ListView(listId: list.id), label: {
                                    ZStack(alignment: .bottom) {
                                        Rectangle()
                                            .fill(Color("HeaderColor"))
                                            .frame(width: 160, height: 75)
                                            .cornerRadius(15)
                                            .shadow(color: Color("Shadow"), radius: 10)
                                        
                                        Text(list.title)
                                            .bold()
                                            .foregroundColor(Color.white)
                                            .frame(alignment: .center)
                                            .lineLimit(1)
                                            .padding(.bottom)
                                            .padding(.horizontal)
                                        
                                        Image(systemName: list.favorite ? "heart.fill" : "heart")
                                            .foregroundColor(list.favorite ? Color("Favorite") : Color.white)
                                            .position(x: 145, y: 22)
                                            .onTapGesture {
                                                #warning("revisar toggleListFavorite")
                                                integration.listsViewModel.toggleListFavorite(of: list)
                                            }
                                    }
                                })
                            }
                        }
                    })
                    .padding(.top)
                }
                .padding(.horizontal)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading){
                        if !lists.isEmpty{
                            Button(action: { isEditing.toggle() }, label: {
                                Text(isEditing ? "Concluir": "Editar")})
                        }
                    }
                    ToolbarItem(placement: .principal){
                        Text("Listas").font(.system(size: 36, weight: .bold)).foregroundColor(Color.primary)
                    }
                    ToolbarItem(placement: .destructiveAction){
                        Button(action: createNewListAction, label: { Text("Nova lista") })
                    }
                }
                
                if lists.isEmpty {
                    Button(action: createNewListAction, label : {
                        Rectangle().fill(Color.clear).frame(width: 200, height: 200)
                    })
                }
            }
            
        }
    }
    
    func createNewListAction() {

        let newList = ListModel(title: "Nova Lista")
        let newListId = newList.id

        integration.createList(newList)
        
        self.listId = newListId
        self.isCreatingList = true
    }
    
}
