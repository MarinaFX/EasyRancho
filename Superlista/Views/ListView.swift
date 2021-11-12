import SwiftUI

struct ListView: View {
    @EnvironmentObject var dataService: DataService
    
    @State var listId: String
    @State var canEditTitle: Bool = false
    @State var list: ListModel?
    @State var listTitle: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            MainScreen(customView:
                ZStack {
                    Color("PrimaryBackground")
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        if let list = self.list {
                            ListHeader(listaTitulo: $listTitle, canEditTitle: $canEditTitle, collaborators: list.sharedWith ?? [], listOwner: list.owner, list: self.list, listId: $listId)
                            
                            NavigationLink(destination: AddNewItemView(list: $list, searchText: "")) {
                                FakeSearchBar()
                                    .padding(.horizontal, 20)
                            }
                            
                            ListPerItemsView(list: $list)
                                .padding(.horizontal)
                                .padding(.bottom, 30)
                            
                        } else {
                            Spacer()
                        }
                    }
                }
            , topPadding: -30)
                .toolbar {
                    ToolbarItem {
                        Button {
                            editTitle()
                        } label: {
                            Text(canEditTitle ? "ListViewLabelA" : "ListViewLabelB")
                        }
                    }
                }
                .onAppear {
                    if list == nil {
                        self.list = getList()
                    }
                    
                    NetworkMonitor.shared.startMonitoring { path in
                        if let sharedWith = list?.sharedWith {
                            if path.status == .satisfied && !sharedWith.isEmpty {
                                dataService.getSharedLists()
                            }
                        }
                    }
                }
                .onChange(of: list) { updatedList in
                    if let updatedList = updatedList {
                        dataService.updateCKListItems(of: updatedList)
                    }
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
}


