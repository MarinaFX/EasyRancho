import SwiftUI
import UIKit
import CloudKit

struct MainView: View {
    @EnvironmentObject var dataService: DataService
    
    @State var isEditing : Bool = false
    @State var listId: String = ""
    @State var isCreatingList: Bool = false
    @State var selectedSection = 0
    @State var createdBy = ""
    @State var counter = 0
    @State var showDialog = false
    @State var listTitle = ""
    @State var hasClickedSettings = false
    
    @ScaledMetric var scaledHeightNewList: CGFloat = 83
    
    @Environment(\.sizeCategory) var sizeCategory

    
    var columns: Array<GridItem>{
        Array(repeating: GridItem(.flexible()), count: sizeCategory >= ContentSizeCategory.extraExtraLarge ? 1 : 2)
    }
    
    let networkMonitor = NetworkMonitor.shared
    
    var appliedSection: [ListModel]{
        let section: [ListModel]
        
        switch selectedSection{
            case 0:
                section =  dataService.lists
            case 1:
                guard let currentUser = dataService.user else { return [] }
                section = dataService.lists.filter{$0.owner.id == currentUser.id}
            case 2:
                guard let currentUser = dataService.user else { return [] }
                section =  dataService.lists.filter{$0.owner.id != currentUser.id}
            default:
                section =  []
        }
        return section
    }
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    NavigationLink(destination: ListView(listId: listId),
                                   isActive: $isCreatingList,
                                   label: { EmptyView() }
                    ).opacity(0.0)
                    
                    if dataService.lists.isEmpty {
                        VStack {
                            Text("EmptyListText")
                                .multilineTextAlignment(.center)
                                .font(.headline)
                                .accessibility(hint: Text("HintEmptyListText"))
                            
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
                        if !dataService.lists.isEmpty {
                            Picker("Lists Sections", selection: $selectedSection) {
                                Text("TudoSegmentedPicker").tag(0)
                                Text("MinhasListasSegmentedPicker").tag(1)
                                Text("ColaborativasSegmentedPicker").tag(2)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        LazyVGrid(columns: columns, alignment: .center, spacing: 20, content: {
                            ForEach(appliedSection) { list in
                                ListCard(list: list, isEditing: isEditing)
                            }
                        }).padding(.top)
                    }
                    .padding(.horizontal)
                    .toolbar{
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                self.hasClickedSettings = true
                            }, label: {
                                Image(systemName: "gearshape.fill")
                            })
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing){
                            if !dataService.lists.isEmpty {
                                Button(action: { isEditing.toggle() }, label: {
                                    Text(isEditing ? "MainViewTrailingNavigationLabelA": "MainViewTrailingNavigationLabelB")})
                                    .accessibility(hint: Text(isEditing ? "HintMainViewTrailingNavigationLabelA": "HintMainViewTrailingNavigationLabelB"))
                            }
                        }
                        
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
                BottomBarButton(action: createNewListAction, text: "AddListMainButton")
                
            }
            .edgesIgnoringSafeArea(.bottom)
        }.sheet(isPresented: $hasClickedSettings) {
            SettingsView(isOpened: $hasClickedSettings)
        }
        .onReceive(dataService.objectWillChange) { _ in
            counter += 1
        }
    }
    
#warning("quando criar uma lista sem estar na internet o newOwner deve ser o user do userdefaults")
    func createNewListAction() {
        guard let user = dataService.user else { return }
        
        let newOwner: OwnerModel = OwnerModel(id: user.id, name: user.name!)
        
        let title = NSLocalizedString("CreateListAlertTitle", comment: "")
        let msg = NSLocalizedString("CreateListAlertText", comment: "")
        let placeholder = NSLocalizedString("NovaLista", comment: "")
        
        textFieldAlert(title: title, message: msg, placeholder: placeholder) { text in
            if let title = text {
                let listTitle = title != "" ? title : placeholder

                let newList: ListModel = ListModel(title: listTitle, owner: newOwner)

                dataService.addList(newList)

                self.listId = newList.id
                self.isCreatingList = true
            }
        }
    }
}
