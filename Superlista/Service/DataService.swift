import Foundation
import CloudKit
import SwiftUI
import Combine

class DataService: ObservableObject {
    
    @Published var user: UserModel? {
        didSet {
            UDService().saveUserOnUD(user: user)
        }
    }
    
    @Published var lists: [ListModel] = [] {
        didSet {
            UDService().saveListsOnUD(lists: lists)
        }
    }
    
    @Published var currentList: ListModel?
    
    let products = ProductListViewModel().productsOrdered
    
    let networkMonitor = NetworkMonitor.shared
    
    var userSubscription: AnyCancellable?
    
    init() {
        getDataIntegration()
    }
    
    func getDataIntegration() {
        self.lists = UDService().getUDLists()
        self.user = UDService().getUDUser()
        
        //if online
        self.userSubscription = CKService.currentModel.userSubject.compactMap({ $0 }).receive(on: DispatchQueue.main).sink { ckUserModel in
            var localLists = UDService().getUDLists()
            
            ckUserModel.myLists?.forEach { list in
                let localList = ListModelConverter().convertCloudListToLocal(withList: list)
                
                let ids = localLists.map(\.id)
                
                if let index = ids.firstIndex(of: list.id.recordName) {
                    localLists[index] = localList
                }
                else {
                    localLists.append(localList)
                }
            }
            
            self.lists = localLists
            
            self.user = UserModelConverter().convertCloudUserToLocal(withUser: ckUserModel)
        }
    }
    
    // MARK: - CRUD user
    func updateUserImageAndName(picture: UIImage, newUsername: String) {
        if let currentUser = self.user {
            self.user = UserModel(id: currentUser.id, name: newUsername, customProducts: currentUser.customProducts, myLists: currentUser.myLists, sharedWithMe: currentUser.sharedWithMe)
        }
        
        networkMonitor.startMonitoring { path in
            if path.status == .satisfied {
                CKService.currentModel.updateUserImageAndName(image: picture, name: newUsername) { result in }
            }
        }
    }
    
    func updateUserName(newUsername: String) {
        if let currentUser = self.user {
            self.user = UserModel(id: currentUser.id, name: newUsername, customProducts: currentUser.customProducts, myLists: currentUser.myLists, sharedWithMe: currentUser.sharedWithMe)
        }
        
        networkMonitor.startMonitoring { path in
            if path.status == .satisfied {
                CKService.currentModel.updateUserName(name: newUsername) { result in }
            }
        }
    }
    
    // MARK: - CRUD lists
    func removeList(_ listModel: ListModel) {
        if let index = lists.firstIndex(where: { $0.id == listModel.id }) {
            
            lists.remove(at: index)
            
            networkMonitor.startMonitoring { path in
                if path.status == .satisfied {
                    CloudIntegration.actions.deleteList(listModel)
                }
            }
        }
    }
    
    func editListTitle(of listModel: ListModel, newTitle: String) {
        if let index = lists.firstIndex(where: { $0.id == listModel.id }) {
            lists[index] = listModel.editTitle(newTitle: newTitle)
            
            networkMonitor.startMonitoring { path in
                if path.status == .satisfied {
                    CloudIntegration.actions.updateListTitle(listModel, newTitle)
                }
            }
        }
    }
    
    func addList(_ newList: ListModel) {
        lists.append(newList)
        
        networkMonitor.startMonitoring { path in
            if path.status == .satisfied {
                CloudIntegration.actions.createList(newList)
            }
        }
    }
    
    // MARK: - CRUD List Items
    func addItem(_ item: ItemModel, to listModel: ListModel) {
        if let index = lists.firstIndex(where: { $0.id == listModel.id }) {
            
            let listWithNewItem = lists[index].addItem(item)
            
            lists[index] = listWithNewItem
            
            networkMonitor.startMonitoring { path in
                if path.status == .satisfied {
                    CloudIntegration.actions.updateCkListItems(updatedList: listWithNewItem)
                }
            }
        }
    }
    
    func removeItem(from row: IndexSet, of category: CategoryModel, of listModel: ListModel) {
        if let index = lists.firstIndex(where: { $0.id == listModel.id }) {
            let listWithoutItem = listModel.removeItem(from: row, of: category)
            
            lists[index] = listWithoutItem
            
            networkMonitor.startMonitoring { path in
                if path.status == .satisfied {
                    CloudIntegration.actions.updateCkListItems(updatedList: listWithoutItem)
                }
            }
        }
    }
    
    func removeItem(_ item: ItemModel, from listModel: ListModel) {
        if let index = lists.firstIndex(where: { $0.id == listModel.id }) {
            let listWithoutItem = listModel.removeItem(item)
            
            lists[index] = listWithoutItem
            
            networkMonitor.startMonitoring { path in
                if path.status == .satisfied {
                    CloudIntegration.actions.updateCkListItems(updatedList: listWithoutItem)
                }
            }
        }
    }
    
    func addComment(_ comment: String, to item: ItemModel, from listModel: ListModel) {
        if let index = lists.firstIndex(where: { $0.id == listModel.id }) {
            let listWithNewItemComment = listModel.addComment(comment, to: item)
            
            lists[index] = listWithNewItemComment
            
            networkMonitor.startMonitoring { path in
                if path.status == .satisfied {
                    CloudIntegration.actions.updateCkListItems(updatedList: listWithNewItemComment)
                }
            }
        }
    }
    
    func toggleCompletion(of item: ItemModel, from listModel: ListModel) {
        if let index = lists.firstIndex(where: { $0.id == listModel.id }) {
            let listWithItemNewState = listModel.toggleCompletion(of: item)
            
            lists[index] = listWithItemNewState
            
            networkMonitor.startMonitoring { path in
                if path.status == .satisfied {
                    CloudIntegration.actions.updateCkListItems(updatedList: listWithItemNewState)
                }
            }
        }
    }
    
    func removeQuantity(of item: ItemModel, from listModel: ListModel) {
        if let index = lists.firstIndex(where: { $0.id == listModel.id }) {
            let listWithNewItemQuantity = listModel.removeQuantity(of: item)
            
            lists[index] = listWithNewItemQuantity
            
            CloudIntegration.actions.updateCkListItems(updatedList: listWithNewItemQuantity)
        }
    }
    
    func addQuantity(of item: ItemModel, from listModel: ListModel) {
        if let index = lists.firstIndex(where: { $0.id == listModel.id }) {
            let listWithNewItemQuantity = listModel.addQuantity(of: item)
            
            lists[index] = listWithNewItemQuantity
            
            CloudIntegration.actions.updateCkListItems(updatedList: listWithNewItemQuantity)
        }
    }
}
