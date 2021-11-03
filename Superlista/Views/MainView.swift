import SwiftUI
import UIKit
import CloudKit

struct MainView: View {
    @EnvironmentObject var dataService: DataService
    
    @State var isEditing : Bool = false
    @State var listId: String = ""
    @State var isCreatingList: Bool = false
    @State var isLoading: Bool = false
    @State var selectedSection = 0
    @State var createdBy = ""
    var appliedSection: [ListModel]{
        switch selectedSection{
        case 0:
            return dataService.lists
        case 1:
            guard let currentUser = dataService.user else { return [] }
            return dataService.lists.filter{$0.owner.id == currentUser.id}
        case 2:
            guard let currentUser = dataService.user else { return [] }
            return dataService.lists.filter{$0.owner.id != currentUser.id}
        default:
            return []
        }
    }
    
    @State var showAlert = false
    var TituloDaNovaLista = "TituloDaNovaLista"
    
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    @State var shouldChangeView = false
    
    var body: some View {
        NavigationView {
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
                        Picker("Lists Sections", selection: $selectedSection) {
                            Text("TudoSegmentedPicker").tag(0)
                            Text("MinhasListasSegmentedPicker").tag(1)
                            Text("ColaborativasSegmentedPicker").tag(2)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        LazyVGrid(columns: columns, spacing: 20, content: {
                            ForEach(appliedSection) { list in
                                
                                // MARK: - editing state
                                if isEditing {
                                    ZStack(alignment: .top) {
                                        
                                        // MARK: - list card
                                        Rectangle()
                                            .fill(Color("Background"))
                                            .frame(width: 171, height: 117)
                                            .cornerRadius(30)
                                            .shadow(color: Color("Shadow"), radius: 12)
                                        
                                        VStack(alignment: .leading){
                                            
                                            // MARK: - list title
                                            Text(list.title)
                                                .font(.callout)
                                                .fontWeight(.semibold)
                                                .foregroundColor(Color.white)
                                                .lineLimit(1)
                                                .padding(.top, 20)
                                            
                                            //MARK: - List Owner
                                            if let listOwner = list.owner.name{
                                                Text(listOwner == CKService.currentModel.user?.name ? "CriadaPorMim" : "CriadaPor \(String(describing: listOwner))")
                                                    .font(.footnote)
                                                    .foregroundColor(Color.white)
                                                    .lineLimit(1)
                                                    .padding(.bottom, 20)
                                                    .truncationMode(.tail)
                                            }
                                            HStack{
                                                if let sharedList = list.sharedWith{
                                                    Text(sharedList.isEmpty ? "0" : (String(describing: sharedList.count)))
                                                        .font(.footnote)
                                                        .foregroundColor(Color.white)
                                                        .lineLimit(1)
                                                }
                                                
                                                Image(systemName: "person.2.fill")
                                                    .font(.caption)
                                                    .foregroundColor(Color.white)
                                                    .padding(.leading, -7)
                                            }
                               
                                            // MARK: - delete button
                                            Image(systemName: "minus.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(.red)
                                                .offset(x: 110, y: -100)
                                                .onTapGesture {
                                                    dataService.currentList = list
                                                    showAlert = true
                                                }
                                        }
                                        .padding(.horizontal, 25)
                                        
                                        
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
                                    .onDrop(of: [.url], delegate: ListDropViewDelegate(dataService: dataService, list: list))
                                    
                                }
                                // MARK: - normal state
                                else {
                                    // MARK: - list card
                                    NavigationLink(destination: ListView(listId: list.id), label: {
                                        ZStack(alignment: .top) {
                                            
                                            // MARK: - list card
                                            Rectangle()
                                                .fill(Color("Background"))
                                                .frame(width: 171, height: 117)
                                                .cornerRadius(30)
                                                .shadow(color: Color("Shadow"), radius: 12)
                                            
                                            VStack(alignment: .leading){
                                                
                                                // MARK: - list title
                                                Text(list.title)
                                                    .font(.callout)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(Color.white)
                                                    .lineLimit(1)
                                                    .padding(.top, 20)
                                                
                                                //MARK: - List Owner
                                                if let listOwner = list.owner.name{
                                                    Text(listOwner == CKService.currentModel.user?.name ? "CriadaPorMim" : "CriadaPor \(String(describing: listOwner))")
                                                        .font(.footnote)
                                                        .foregroundColor(Color.white)
                                                        .lineLimit(1)
                                                        .padding(.bottom, 20)
                                                        .truncationMode(.tail)
                                                }
                                                HStack{
                                                    if let sharedList = list.sharedWith{
                                                        Text(sharedList.isEmpty ? "0" : (String(describing: sharedList.count)))
                                                            .font(.footnote)
                                                            .foregroundColor(Color.white)
                                                            .lineLimit(1)
                                                    }
                                                    
                                                    Image(systemName: "person.2.fill")
                                                        .font(.caption)
                                                        .foregroundColor(Color.white)
                                                        .padding(.leading, -7)
                                                }
                                            }
                                            .padding(.horizontal, 25)
                                            
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
                            // MARK: - new list button
                            ToolbarItem(placement: .navigationBarTrailing){
                                Button(action: createNewListAction, label: { Text("NovaLista") })
                            }
                            // MARK: - title
                            ToolbarItem(placement: .principal){
                                Text("ListasTitle")
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundColor(Color.primary)
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
    }
    
#warning("quando criar uma lista sem estar na internet o newOwner deve ser o user do userdefaults")
    func createNewListAction() {
        guard let user = dataService.user else { return }
        
        let newOwner: OwnerModel = OwnerModel(id: user.id, name: user.name!)
        let newList: ListModel = ListModel(title: "Nova Lista", owner: newOwner)
        
        dataService.addList(newList)
        
        self.listId = newList.id
        self.isCreatingList = true
    }
}
