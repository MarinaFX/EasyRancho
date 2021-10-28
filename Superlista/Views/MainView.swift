import SwiftUI
import UIKit
import CloudKit

struct MainView: View {
    @EnvironmentObject var dataService: DataService
    
    @State var isEditing : Bool = false
    @State var listId: String = ""
    @State var isCreatingList: Bool = false
    @State var isLoading: Bool = false
    
    @State var showAlert = false
    var TituloDaNovaLista = "TituloDaNovaLista"
    
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
                Color("PrimaryBackground")
                    .ignoresSafeArea()
                
                // MARK: - empty state
                if dataService.lists.isEmpty {
                    VStack {
                        Text("listaVazia")
                            .multilineTextAlignment(.center)
                            .font(.headline)
                        
                        NoItemsView()
                            .frame(width: 400, height: 400)
                    }
                    .onAppear {
                        if dataService.lists.isEmpty {
                            self.isEditing = false
                        }
                    }
                }
                
                // MARK: - Lists
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 20, content: {
                        ForEach(dataService.lists) { list in
                            
                            // MARK: - editing state
                            if isEditing {
                                ZStack(alignment: .bottom) {
                                    
                                    // MARK: - list card
                                    Rectangle()
                                        .fill(Color("Background"))
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
                                    
                                    // MARK: - delete button
                                    Image(systemName: "minus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(Color(.systemGray))
                                        .offset(x: -75, y: -60)
                                        .onTapGesture {
                                            dataService.currentList = list
                                            showAlert = true
                                        }
                                }
                                .alert(isPresented: $showAlert){
                                    Alert(title: Text("remover \(dataService.currentList!.title)"), message: Text("subtituloRemoverLista"), primaryButton: .cancel(), secondaryButton: .destructive(Text("ApagarLista"), action:{
                                        dataService.removeList(dataService.currentList!)
                                        showAlert = false
                                    }))
                                }
                                // MARK: - list cards drag and drop
                                .onDrag({
                                    dataService.currentList = list
                                    return NSItemProvider(contentsOf: URL(string: "\(list.id)")!)!
                                })
                                .onDrop(of: [.url], delegate: ListDropViewDelegate(listsViewModel: dataService, list: list))
                                
                            }
                            // MARK: - normal state
                            else {
                                // MARK: - list card
                                NavigationLink(destination: ListView(listId: list.id), label: {
                                    ZStack(alignment: .bottom) {
                                        
                                        // MARK: - list card
                                        Rectangle()
                                            .fill(Color("Background"))
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
                        if !dataService.lists.isEmpty {
                            Button(action: {isEditing.toggle()}, label: {
                                Text(isEditing ? "ConcluirListas": "EditarListas")})
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
                        Button(action: createNewListAction, label: { Text("NovaLista") })
                    }
                }
                
                // MARK: - transparent new list button
                if dataService.lists.isEmpty {
                    Button(action: createNewListAction, label : {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: 200, height: 200)
                    })
                }
            }
        }
    }
    
    #warning("quando criar uma lista sem estar na internet o newOwner deve ser o user do userdefaults")
    func createNewListAction() {
        let newOwner: OwnerModel = OwnerModel(id: CKService.currentModel.user!.id.recordName, name:  CKService.currentModel.user!.name!)
        let newList: ListModel = ListModel(title: "Nova Lista", owner: newOwner)

        dataService.addList(newList)
        self.listId = newList.id
        self.isCreatingList = true
    }
    
}
