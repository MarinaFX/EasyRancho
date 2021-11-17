import SwiftUI

struct ListView: View {
    @EnvironmentObject var dataService: DataService
    
    @State var listId: String
    @State var canEditTitle: Bool = false
    @State var listTitle: String = ""
    @State var isPresentedAddNewItems: Bool = false
    @State var list: ListModel?
    @State var isFirstAppear: Bool = true
    
    let networkMonitor = NetworkMonitor.shared
    
    var body: some View {
        MainScreen(customView:
                    ZStack {
            NavigationLink("", isActive: $isPresentedAddNewItems, destination: { AddNewItemView(list: self.$list, searchText: "") })
            
            Color("PrimaryBackground")
                .ignoresSafeArea()
            
            VStack (spacing: 10) {
                if let list = self.list {
                    ListHeader(listTitle: $listTitle, canEditTitle: $canEditTitle, collaborators: list.sharedWith ?? [], listOwner: list.owner, list: self.list, listId: $listId)
                    
                    ListPerItemsView(list: $list)
                        .padding(.horizontal)
                        .padding(.bottom, -10)
                    
                    if let sharedWith = list.sharedWith {
                        if (networkMonitor.status == .satisfied) || sharedWith.isEmpty {
                            BottomBarButton(action: addNewItemAction, text: "AddItemsButton")
                        }
                    }
                    
                } else {
                    Spacer()
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }, topPadding: -30)
            .toolbar{
                ToolbarItem {
                    Button {
                        editTitle()
                    } label: {
                        Text(canEditTitle ? "ListViewLabelA" : "ListViewLabelB")
                            .foregroundColor(getForegroundColor(list: list, networkMonitor: networkMonitor) ? Color.primary : Color(UIColor.secondaryLabel))
                    }
                    .disabled(!getForegroundColor(list: list, networkMonitor: networkMonitor))
                }
            }
            .onAppear {
                if self.list == nil {
                    self.list = getList()
                }
                
                guard isFirstAppear else { return }
                isFirstAppear = false
                
                NetworkMonitor.shared.startMonitoring { path in
                    if let sharedWith = list?.sharedWith {
                        if path.status == .satisfied && !sharedWith.isEmpty {
                            dataService.refreshUser()
                        }
                    }
                }
            }
            .onChange(of: list) { newValue in
                if let updatedList = newValue {
                    dataService.updateList(of: updatedList)
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

