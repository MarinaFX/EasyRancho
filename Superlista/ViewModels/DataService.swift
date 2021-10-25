import Foundation
import CloudKit
import SwiftUI
import Combine

class DataService: ObservableObject {
    
    static var user: UserModel = UserModelConverter().convertCloudUserToLocal(withUser: CKService.currentModel.user!)
    
    @Published var lists: [ListModel] = [] {
        didSet {
            saveDataOnUserDefaults()
        }
    }
    
    @Published var currentList: ListModel?
        
    let products = ProductListViewModel().productsOrdered
    
    let userDefaultsKey: String = "lists"
    
    let networkMonitor = NetworkMonitor.shared
    
    var userSubscription: AnyCancellable?

    init() {
        getListsIntegration()
    }
    
    func getListsIntegration() {
        self.lists = getUserDefaults()

        networkMonitor.startMonitoring { path in
            if path.status == .satisfied {

                self.userSubscription = CKService.currentModel.userSubject.compactMap({ $0 }).receive(on: DispatchQueue.main).sink { ckUserModel in
                    
                    var userDefaults = self.getUserDefaults()
                    
                    ckUserModel.myLists?.forEach { list in
                        if !userDefaults.contains(where: { $0.id == list.id.recordName }) {
                            
                            let localList = ListModelConverter().convertCloudListToLocal(withList: list)
                            userDefaults.append(localList)
                        }
                    }

                    self.lists = userDefaults
                }
            }
        }
    }
    
    // MARK: - User Defaults
    func getUserDefaults() -> [ListModel] {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let savedItems = try? JSONDecoder().decode([ListModel].self, from: data) {
            
            return savedItems
        }
        return []
    }
    
    func saveDataOnUserDefaults() {
        if let encodedData = try? JSONEncoder().encode(lists) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
        }
    }
    
    // MARK: - CRUD lists
    func removeList(_ listModel: ListModel) {
        if let index = lists.firstIndex(where: { $0.id == listModel.id }) {
            
            lists.remove(at: index)
            
            CloudIntegration.actions.deleteList(listModel)
        }
    }
    
    func editListTitle(of listModel: ListModel, newTitle: String) {
        if let index = lists.firstIndex(where: { $0.id == listModel.id }) {
            lists[index] = listModel.editTitle(newTitle: newTitle)
            
            CloudIntegration.actions.updateListTitle(listModel, newTitle)
        }
    }
    
    func addList(_ newList: ListModel) {
        lists.append(newList)
        
        CloudIntegration.actions.createList(newList)
    }
    
    // MARK: - CRUD List Items
    func addItem(_ item: ItemModel, to listModel: ListModel) {
        if let index = lists.firstIndex(where: { $0.id == listModel.id }) {
            
            let listWithNewItem = lists[index].addItem(item)
            
            lists[index] = listWithNewItem
            
            CloudIntegration.actions.updateCkListItems(updatedList: listWithNewItem)
        }
    }
    
    func removeItem(from row: IndexSet, of category: CategoryModel, of listModel: ListModel) {
        if let index = lists.firstIndex(where: { $0.id == listModel.id }) {
            let listWithoutItem = listModel.removeItem(from: row, of: category)
            
            lists[index] = listWithoutItem
            
            CloudIntegration.actions.updateCkListItems(updatedList: listWithoutItem)
        }
    }
    
    func removeItem(_ item: ItemModel, from listModel: ListModel) {
        if let index = lists.firstIndex(where: { $0.id == listModel.id }) {
            let listWithoutItem = listModel.removeItem(item)
            
            lists[index] = listWithoutItem
            
            CloudIntegration.actions.updateCkListItems(updatedList: listWithoutItem)
        }
    }
    
    func addComment(_ comment: String, to item: ItemModel, from listModel: ListModel) {
        if let index = lists.firstIndex(where: { $0.id == listModel.id }) {
            let listWithNewItemComment = listModel.addComment(comment, to: item)
            
            lists[index] = listWithNewItemComment
            
            CloudIntegration.actions.updateCkListItems(updatedList: listWithNewItemComment)
        }
    }
    
    func toggleCompletion(of item: ItemModel, from listModel: ListModel) {
        if let index = lists.firstIndex(where: { $0.id == listModel.id }) {
            let listWithItemNewState = listModel.toggleCompletion(of: item)
            
            lists[index] = listWithItemNewState
            
            CloudIntegration.actions.updateCkListItems(updatedList: listWithItemNewState)
        }
    }
}