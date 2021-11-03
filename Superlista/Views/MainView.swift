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
    @State var shouldChangeView = false

    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                
                NavigationLink(destination: ListView(listId: listId),
                               isActive: $isCreatingList,
                               label: { EmptyView() }
                )
                .opacity(0.0)
                
                Color("PrimaryBackground")
                    .ignoresSafeArea()
                
                if dataService.lists.isEmpty {
                    VStack {
                        Text("EmptyListText")
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
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 20, content: {
                        ForEach(dataService.lists) { list in
                            
                            if isEditing {
                                ZStack(alignment: .bottom) {
                                    
                                    Rectangle()
                                        .fill(Color("Background"))
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
                                    Alert(title: Text("Remover \(dataService.currentList!.title)"), message: Text("DeleteListAlertText"), primaryButton: .cancel(), secondaryButton: .destructive(Text("DeleteListAlertButton"), action: {
                                        dataService.removeList(dataService.currentList!)
                                        showAlert = false
                                    }))
                                }
                                .onDrag({
                                    dataService.currentList = list
                                    return NSItemProvider(contentsOf: URL(string: "\(list.id)")!)!
                                })
                                .onDrop(of: [.url], delegate: ListDropViewDelegate(dataService: dataService, list: list))
                                
                            }
                            else {
                                NavigationLink(destination: ListView(listId: list.id), label: {
                                    ZStack(alignment: .bottom) {
                                        
                                        Rectangle()
                                            .fill(Color("Background"))
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
                                        
                                    }
                                })
                            }
                        }
                    }).padding(.top)
                }.padding(.horizontal)
                
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading){
                        if !dataService.lists.isEmpty {
                            Button(action: {isEditing.toggle()}, label: {
                                Text(isEditing ? "MainViewTrailingNavigationLabelA": "MainViewTrailingNavigationLabelB")})
                        }
                    }
                    
                    ToolbarItem(placement: .principal){
                        Text("MainViewTitle")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(Color.primary)
                    }
                    
                    ToolbarItem(placement: .destructiveAction){
                        Button(action: createNewListAction, label: { Text("MainViewLeadingNavigationLabel") })
                    }
                }
                
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
        guard let user = dataService.user else { return }
        
        let newOwner: OwnerModel = OwnerModel(id: user.id, name: user.name!)
        let newList: ListModel = ListModel(title: NSLocalizedString("NovaLista", comment: "Nova Lista"), owner: newOwner)

        dataService.addList(newList)
        
        self.listId = newList.id
        self.isCreatingList = true
    }
    
}
