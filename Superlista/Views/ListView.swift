import SwiftUI

struct ListView: View {
    @EnvironmentObject var dataService: DataService
    
    @State var hasChangedItems = false
    @State var listId: String
    @State var canEditTitle: Bool = false
    @State var listTitle: String = ""
    @State var isPresentedAddNewItems: Bool = false
    
    var list: ListModel? {
        let myList = getList()
        return myList
    }
    
    let networkMonitor = NetworkMonitor.shared
    
    var body: some View {
        MainScreen(customView:
            ZStack {
            if let list = list {
                NavigationLink("", isActive: $isPresentedAddNewItems, destination: { AddNewItemView(list: list, hasChangedItems: $hasChangedItems, searchText: "") })
            }
            
                Color("PrimaryBackground")
                    .ignoresSafeArea()
                
                VStack (spacing: 10) {
                    if let list = self.list {
                        ListHeader(listaTitulo: $listTitle, canEditTitle: $canEditTitle, collaborators: list.sharedWith ?? [], listOwner: list.owner, list: self.list, listId: $listId)
                        
                        ListPerItemsView(list: list)
                            .padding(.horizontal)
                            .padding(.bottom, -10)
                                                
                        BottomBarButton(action: addNewItemAction, text: "AddItemsButton")
                        
                    } else {
                        Spacer()
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        , topPadding: -30)
            .toolbar{
                ToolbarItem {
                    Button {
                        editTitle()
                    } label: {
                        Text(canEditTitle ? "ListViewLabelA" : "ListViewLabelB")
                            .foregroundColor((networkMonitor.status == .satisfied) ? Color.primary : Color(UIColor.secondaryLabel))
                    }
                    .disabled(!(networkMonitor.status == .satisfied))
                }
            }
            .onAppear {
                NetworkMonitor.shared.startMonitoring { path in
                    if let sharedWith = list?.sharedWith {
                        if path.status == .satisfied && !sharedWith.isEmpty {
                            dataService.refreshUser()
                        }
                    }
                }
            
                if hasChangedItems, let list = self.list {
                    dataService.updateCKListItems(of: list)
                    self.hasChangedItems = false
                }
            }
    }
    
    // MARK: - getList()
    func getList() -> ListModel? {
        if let list = dataService.lists.first(where: { $0.id == listId }) {
            return list
        }
        return nil
    }
    
    // MARK: - editList()
    func editTitle() {
        if let unwrappedList = self.list {
            if canEditTitle && !listTitle.isEmpty {
                dataService.editListTitle(of: unwrappedList, newTitle: listTitle)
                canEditTitle = false
            } else {
                canEditTitle = true
            }
        }
    }
    
    func addNewItemAction() {
        self.isPresentedAddNewItems = true
    }
}

