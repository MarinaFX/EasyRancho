import SwiftUI
import UIKit
import CloudKit

struct MainView: View {
    @EnvironmentObject var listsViewModel: DataService
    
    @State var isEditing : Bool = false
    @State var listId: String = ""
    @State var isCreatingList: Bool = false
    @State var isLoading: Bool = false
    
    @State var showAlert = false
    
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    @State var shouldChangeView = false
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                
                // MARK: - new list button
                NavigationLink(destination: ListView(listId: listId),
                               isActive: $isCreatingList,
                               label: { EmptyView() }
                )
                .opacity(0.0)
                
                // MARK: - background color
                Color("background")
                    .ignoresSafeArea()
                
                // MARK: - empty state
                if listsViewModel.lists.isEmpty {
                    VStack {
                        
                        Text("Você não tem nenhuma lista!\nQue tal adicionar uma nova lista?")
                            .multilineTextAlignment(.center)
                            .font(.headline)
                        
                        NoItemsView()
                            .frame(width: 400, height: 400)
                    }
                    .onAppear {
                        if listsViewModel.lists.isEmpty {
                            self.isEditing = false
                        }
                    }
                }
                
                // MARK: - Lists
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 20, content: {
                        ForEach(listsViewModel.lists) { list in
                            
                            // MARK: - editing state
                            if isEditing {
                                ZStack(alignment: .bottom) {
                                    
                                    // MARK: - list card
                                    Rectangle()
                                        .fill(Color("HeaderColor"))
                                        .frame(width: 160, height: 75)
                                        .cornerRadius(15)
                                        .shadow(color: Color("Shadow"), radius: 10)
                                    
                                    // MARK: - list title
                                    Text(list.title)
                                        .bold()
                                        .foregroundColor(Color.white)
                                        .frame(alignment: .center)
                                        .lineLimit(1)
                                        .padding(.bottom)
                                        .padding(.horizontal)
                                    
                                    // MARK: - favorite button
                                    Image(systemName: list.favorite ? "heart.fill" : "heart")
                                        .foregroundColor(list.favorite ? Color("Favorite") : Color.white)
                                        .position(x: 150, y: 22)
                                        .onTapGesture {
                                            listsViewModel.toggleListFavorite(of: list)
                                        }
                                    
                                    // MARK: - delete button
                                    Image(systemName: "minus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(Color(.systemGray))
                                        .offset(x: -75, y: -60)
                                        .onTapGesture {
                                            listsViewModel.currentList = list
                                            showAlert = true
                                        }
                                }
                                // MARK: - on press delete action
                                .alert(isPresented: $showAlert) {
                                    var listName = "uma lista"
                                    
                                    if let currentList = listsViewModel.currentList {
                                        listName = currentList.title
                                    }
                                    
                                    return Alert(
                                        title: Text("Deseja remover \(listName)?"),
                                        message: Text("A lista removida não poderá ser recuperada após sua exclusão"),
                                        primaryButton: .cancel(),
                                        secondaryButton: .destructive(
                                            Text("Apagar"),
                                            action: {
                                                listsViewModel.removeList(listsViewModel.currentList!)
                                                showAlert = false
                                            })
                                    )
                                }
                                // MARK: - list cards drag and drop
                                .onDrag({
                                    listsViewModel.currentList = list
                                    return NSItemProvider(contentsOf: URL(string: "\(list.id)")!)!
                                })
                                .onDrop(of: [.url], delegate: ListDropViewDelegate(listsViewModel: listsViewModel, list: list))
                                
                            }
                            // MARK: - normal state
                            else {
                                // MARK: - list card
                                NavigationLink(destination: ListView(listId: list.id), label: {
                                    ZStack(alignment: .bottom) {
                                        
                                        // MARK: - list card
                                        Rectangle()
                                            .fill(Color("HeaderColor"))
                                            .frame(width: 160, height: 75)
                                            .cornerRadius(15)
                                            .shadow(color: Color("Shadow"), radius: 10)
                                        
                                        // MARK: - list title
                                        Text(list.title)
                                            .bold()
                                            .foregroundColor(Color.white)
                                            .frame(alignment: .center)
                                            .lineLimit(1)
                                            .padding(.bottom)
                                            .padding(.horizontal)
                                        
                                        // MARK: - fav button
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
                    }).padding(.top)
                }.padding(.horizontal)
                
                // MARK: - toolbar
                .toolbar{
                    
                    // MARK: - edit button
                    ToolbarItem(placement: .navigationBarLeading){
                        if !listsViewModel.lists.isEmpty {
                            Button(action: { isEditing.toggle() }, label: {
                                Text(isEditing ? "Concluir": "Editar")
                            })
                        }
                    }
                    
                    // MARK: - title
                    ToolbarItem(placement: .principal){
                        Text("Listas")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(Color.primary)
                    }
                    
                    // MARK: - new list button
                    ToolbarItem(placement: .destructiveAction){
                        Button(action: createNewListAction, label: { Text("Nova lista") })
                    }
                }
                
                // MARK: - transparent new list button
                if listsViewModel.lists.isEmpty {
                    Button(action: createNewListAction, label : {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: 200, height: 200)
                    })
                }
            }
        }
    }
    
    func createNewListAction() {
        let newList: ListModel = ListModel(title: "Nova Lista")

        listsViewModel.addList(newList)
                
        self.listId = newList.id
        self.isCreatingList = true
    }
    
}

