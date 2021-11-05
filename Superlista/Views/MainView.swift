import SwiftUI
import UIKit
import CloudKit

struct MainView: View {
    @EnvironmentObject var dataService: DataService
    
    @State var isEditing : Bool = false
    @State var listId: String = ""
    @State var isCreatingList: Bool = false
    @State var selectedSection = 0
    
    var currentSection: [ListModel] {
        switch selectedSection {
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
    
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
        
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(destination: ListView(listId: listId),
                               isActive: $isCreatingList,
                               label: { EmptyView() }
                ).opacity(0.0)
                
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
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(currentSection) { list in
                            if isEditing {
                                ListCard(isEditing: true, list: list)
                            } else {
                                NavigationLink(destination: ListView(listId: list.id), label: {
                                    ListCard(isEditing: false, list: list)
                                })
                            }
                        }
                    }
                    .padding(.top)
                }
                .padding(.horizontal)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading){
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape.fill")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing){
                        if !dataService.lists.isEmpty {
                            Button(action: { isEditing.toggle() }, label: {
                                Text(isEditing ? "MainViewTrailingNavigationLabelA": "MainViewTrailingNavigationLabelB")})
                        }
                    }
                    
                    ToolbarItem(placement: .principal){
                        Text("MainViewTitle")
                            .font(.largeTitle)
                            .fontWeight(.bold)
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
        .background(Color("PrimaryBackground"))
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
