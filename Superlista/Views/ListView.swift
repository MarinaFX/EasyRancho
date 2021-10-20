import SwiftUI

struct ListView: View {
    @EnvironmentObject var listsViewModel: DataService

    @State var hasChangedItems = false
    @State var listId: String
    @State var canEditTitle: Bool = false
    
    var list: ListModel? {
        return getList()
    }
    
    @State var listTitle: String = ""
    
    
    
    var body: some View {
        GeometryReader { geometry in
            MainScreen(customView: AnyView(
                ZStack {
                    // MARK: - background color
                    Color("background")
                        .ignoresSafeArea()
                    
                    VStack (spacing: 20) {
                        // MARK: - header
                        ListHeader(listaTitulo: $listTitle, canEditTitle: $canEditTitle, list: self.list, listId: $listId)
                        
                        if let list = self.list {
                            
                            // MARK: - search bar
                            NavigationLink(destination: AddNewItemView(list: list, hasChangedItems: $hasChangedItems, searchText: "")){
                                FakeSearchBar()
                                    .padding(.horizontal, 20)
                            }
                            
                            // MARK: - list component
                            ListPerItemsView(list: list)
                                .padding(.horizontal)
                                .padding(.bottom, 30)
                            
                        } else {
                            Spacer()
                        }
                    }
                }
            ), topPadding: -30)
            
            // MARK: - toolbar
                .toolbar{
                    
                    // MARK: - edit button
                    ToolbarItem {
                        Button {
                            editTitle()
                        } label: {
                            Text(canEditTitle ? "Salvar" : "Editar")
                        }
                    }
                }
            // MARK: - onAppear
                .onAppear {
                                        
                    if hasChangedItems, let list = self.list {
                        CloudIntegration.actions.updateCkListItems(updatedList: list)
                        
                        self.hasChangedItems = false
                    }
                }
        }
    }
    
    // MARK: - getList()
    func getList() -> ListModel? {
        if let list = listsViewModel.lists.first(where: { $0.id == listId }) {
            return list
        }
        return nil
    }
    
    // MARK: - editList()
    func editTitle() {
        if let unwrappedList = self.list {
            if canEditTitle && !listTitle.isEmpty {
                listsViewModel.editListTitle(of: unwrappedList, newTitle: listTitle)
                canEditTitle = false
            } else {
                canEditTitle = true
            }
        }
    }
}

