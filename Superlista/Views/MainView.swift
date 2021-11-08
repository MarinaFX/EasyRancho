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
    
    @State var showAlertDelete = false
    @State var showDialog = false
    @State var listTitle = ""
    @State var showAlertDuplicate = false
    @State var editNavigation = false
    @State var hasClickedSettings = false
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    
                    NavigationLink(destination: ListView(listId: listId),
                                   isActive: $isCreatingList,
                                   label: { EmptyView() }
                    ).opacity(0.0)
                    
//                    NavigationLink(destination: SettingsView(),
//                                   isActive: $hasClickedSettings,
//                                   label: { EmptyView() }
//                    ).opacity(0.0)
                    
                    Color("PrimaryBackground")
                        .ignoresSafeArea()
                    
                    if dataService.lists.isEmpty {
                        EmptyView()
                            .onAppear {
                                if dataService.lists.isEmpty {
                                    self.isEditing = false
                                }
                            }
                    }
                    ScrollView(showsIndicators: false) {
                        Picker("Lists Sections", selection: $selectedSection) {
                            Text("TudoSegmentedPicker").tag(0)
                            Text("MinhasListasSegmentedPicker").tag(1)
                            Text("ColaborativasSegmentedPicker").tag(2)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        LazyVGrid(columns: columns, spacing: 20, content: {
                            ForEach(appliedSection) { list in
                                
                                NavigationLink(destination: ListView(listId: list.id), label: {
                                    ZStack(alignment: .leading) {
                                        
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
                                            
                                            //MARK: - List Owner
                                            if let listOwner = list.owner.name{
                                                Text(listOwner == dataService.user?.name ? "CriadaPorMim" : "CriadaPor \(String(describing: listOwner))")
                                                    .font(.footnote)
                                                    .foregroundColor(Color.white)
                                                    .lineLimit(1)
                                                    .truncationMode(.tail)
                                                    .padding(.bottom, 25)
                                            }
                                            HStack {
                                                HStack (alignment: .bottom) {
                                                    if let sharedList = list.sharedWith {
                                                        if !sharedList.isEmpty {
                                                            Image(systemName: "person.2.fill")
                                                                .font(.body)
                                                                .foregroundColor(Color.white)
                                                            
                                                            Text(sharedList.isEmpty ? "0" : (String(describing: sharedList.count)))
                                                                .font(.footnote)
                                                                .foregroundColor(Color.white)
                                                                .lineLimit(1)
                                                                .padding(.trailing)
                                                        }
                                                    }
                                                }
                                                
                                                Spacer()
                                                
                                                Image(systemName: "ellipsis.circle.fill")
                                                    .font(.body)
                                                    .foregroundColor(Color.white)
                                                    .contextMenu {
                                                        Button {
                                                            dataService.currentList = list
                                                            editNavigation = true
                                                        } label: {
                                                            Label("ContextMenu1", systemImage: "pencil")
                                                        }
                                                        .accessibilityLabel(Text("Option1"))
                                                        .accessibility(hint: Text("Option1Hint"))
                                                        
                                                        Button {
                                                            dataService.currentList = list
                                                            showAlertDuplicate = true
                                                        } label: {
                                                            Label("ContextMenu2", systemImage: "doc.on.doc")
                                                        }
                                                        .accessibilityLabel(Text("Option2"))
                                                        .accessibility(hint: Text("Option2Hint"))
                                                        
                                                        Button {
                                                            guard let ownerName = list.owner.name else { return }
                                                            shareSheet(listID: list.id, option: "1", listName: list.title, ownerName: ownerName)
                                                        } label: {
                                                            Label("ContextMenu3", systemImage: "person.crop.circle.badge.plus")
                                                        }
                                                        .accessibilityLabel(Text("Option3"))
                                                        .accessibility(hint: Text("Option3Hint"))
                                                        
                                                        Button {
                                                            guard let ownerName = list.owner.name else { return }
                                                            shareSheet(listID: list.id, option: "2", listName: list.title, ownerName: ownerName)
                                                        } label: {
                                                            Label("ContextMenu4", systemImage: "square.and.arrow.up")
                                                        }
                                                        .accessibilityLabel(Text("Option4"))
                                                        .accessibility(hint: Text("Option4Hint"))
                                                        
                                                        Button {
                                                            dataService.currentList = list
                                                            showAlertDelete = true
                                                        } label: {
                                                            Label("ContextMenu5", systemImage: "trash")
                                                        }
                                                        .accessibilityLabel(Text("Option5"))
                                                        .accessibility(hint: Text("Option5Hint"))
                                                    }
                                                    .accessibilityLabel(Text("Options"))
                                                    .accessibility(hint: Text("MoreOptions"))
                                                
                                            }
                                        }
                                        .padding(.horizontal, 20)
                                        ZStack {
                                            NavigationLink(destination: ListView(listId: dataService.currentList?.id ?? "123"), isActive: $editNavigation) {
                                                EmptyView()
                                            }
                                        }
                                        .alert(isPresented: $showAlertDelete){
                                            Alert(title: Text("Remover \(dataService.currentList!.title)"), message: Text("DeleteListAlertText"), primaryButton: .cancel(), secondaryButton: .destructive(Text("DeleteListAlertButton"), action:{
                                                dataService.removeList(dataService.currentList!)
                                                showAlertDelete = false
                                            }))
                                        }
                                        ZStack {
                                            
                                        }
                                        .alert(isPresented: $showAlertDuplicate){
                                            Alert(title: Text("Duplicar \(dataService.currentList!.title)"), message: Text("DuplicateListAlertText"), primaryButton: .cancel(), secondaryButton: .default(Text("DuplicateListAlertButton"), action:{
                                                dataService.duplicateList(of: dataService.currentList!)
                                                showAlertDuplicate = false
                                            }))
                                        }
                                        
                                        if isEditing {
                                            Image(systemName: "minus.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(Color(.systemGray))
                                                .offset(x: 150, y: -45)
                                                .onTapGesture {
                                                    dataService.currentList = list
                                                    showAlertDelete = true
                                                }
                                        }
                                    }
                                })
                            }
                        }).padding(.top)
                    }.padding(.horizontal)
                    
                    // MARK: - toolbar
                        .toolbar{
                            
//                            ToolbarItem(placement: .navigationBarLeading){
//                                //                                NavigationLink(destination: SettingsView(), label: {
//                                //                                    Image(systemName: "gearshape.fill")
//                                //                                })
//                                Button(action: {
//                                    self.hasClickedSettings = true
//                                }, label : {
//                                    Image(systemName: "gearshape.fill")
//                                })
//                            }
                            
                            ToolbarItem(placement: .navigationBarTrailing){
                                if !dataService.lists.isEmpty {
                                    Button(action: {isEditing.toggle()}, label: {
                                        Text(isEditing ? "MainViewTrailingNavigationLabelA": "MainViewTrailingNavigationLabelB")})
                                }
                            }
                            
                            // MARK: - title
                            ToolbarItem(placement: .principal){
                                Text("MainViewTitle")
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
                
                FooterButton(action: createNewListAction)
            }.edgesIgnoringSafeArea(.bottom)
        }
    }
    
#warning("quando criar uma lista sem estar na internet o newOwner deve ser o user do userdefaults")
    func createNewListAction() {
        guard let user = dataService.user else { return }
        
        let newOwner: OwnerModel = OwnerModel(id: user.id, name: user.name!)
        
        alertMessage(title: "Criar nova lista", message: "Dê um nome para sua nova lista", placeholder: "Nova Lista") { text in
            if let title = text {
                let listTitle = title != "" ? title : NSLocalizedString("NovaLista", comment: "List title")
                
                let newList: ListModel = ListModel(title: listTitle, owner: newOwner)
                
                dataService.addList(newList)
                
                self.listId = newList.id
                self.isCreatingList = true
            }
        }
    }
}

struct EmptyState: View {
    var body: some View {
        VStack {
            Text("EmptyListText")
                .multilineTextAlignment(.center)
                .font(.headline)
            
            NoItemsView()
                .frame(width: 400, height: 400)
        }
    }
}

struct FooterButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .trailing) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                    
                    Text("AddListMainButton")
                        .fontWeight(.bold)
                        .font(.title3)
                    
                    Spacer()
                }
                .foregroundColor(Color("Button"))
                .padding(.bottom, 34)
                .padding(.horizontal, 14)
                .padding(.top, 18)
                
            }
            .frame(width: UIScreen.main.bounds.width, height: 83)
            .background(Color("ButtonBG"))
            .overlay(Rectangle().fill(Color(UIColor.systemGray5)).frame(width: UIScreen.main.bounds.width, height: 1), alignment: .top)
        }
    }
}

func alertMessage(title: String, message: String, placeholder: String, actionHandler: @escaping (String?) -> Void) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    alert.addTextField { textField in
        textField.placeholder = placeholder
    }
    
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in actionHandler(alert.textFields?.first?.text)
    }))
    
    let viewController = UIApplication.shared.windows.first!.rootViewController!
    
    viewController.present(alert, animated: true)
}
