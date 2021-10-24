import SwiftUI
import UIKit
import CloudKit

@main
struct SuperlistaApp: App {
    @StateObject var listsViewModel: DataService = DataService()
    
    @State var list: CKListModel?
    
    @State var presentSharedAlert: Bool = false
    @State var presentCollabAlert: Bool = false
    
    init() {
        UITableView.appearance().backgroundColor = UIColor(named: "background")
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ZStack {
                    ZStack {
                        MainView()
                            .onOpenURL(perform: { url in
                                guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
                                      let host = components.host else {
                                          print("Invalid URL")
                                          return
                                      }
                                
                                let deepLink = DeepLink(id: host)
                                
                                handleDeepLink(deepLink)
                                
                            })
                            .alert(isPresented: $presentCollabAlert) {
                                Alert(
                                    title: Text(list?.name ?? "Lista"),
                                    message: Text("Você foi convidado você para colaborar em uma lista. Deseja se tornar um colaborador desta lista?"),
                                    primaryButton:  .default(
                                        Text("Cancelar"),
                                        action: {
                                            presentCollabAlert = false
                                        }),
                                    secondaryButton: .default(
                                        Text("Aceitar"),
                                        action: {
                                            let ds = DispatchSemaphore(value: 1)
                                            ds.wait()
                                            CKService.currentModel.saveListUsersList(listID: list!.id, key: .SharedWithMe) { result in
                                                switch result {
                                                case .success(let listID):
                                                    let user = CKService.currentModel.user!
                                                    var sharedWith = list!.sharedWith
                                                    sharedWith.append(user)
                                                    CKService.currentModel.updateListCollab(listID: listID, sharedWith: sharedWith) { result in
                                                        presentCollabAlert = false
                                                        ds.signal()
                                                    }
                                                case .failure:
                                                    presentCollabAlert = false
                                                    ds.signal()
                                                    return
                                                }
                                            }
                                        }
                                    )
                                )
                            }
                    }
                }
                .alert(isPresented: $presentSharedAlert) {
                    Alert(title: Text(list?.name ?? "Lista"),
                          message: Text("Esta lista foi compartilhada com você. Deseja adicionar uma cópia desta lista?"),
                          primaryButton: .default(
                            Text("Cancelar"), action: {
                                presentSharedAlert = false
                            }),
                          secondaryButton: .default(
                            Text("Aceitar"),
                            action: {
                                let newOwnerRef = CKRecord.Reference(recordID: CKService.currentModel.user!.id, action: .none)
                                let newListLocal = CKListModel(name: list!.name ?? "Nova Lista", ownerRef: newOwnerRef, itemsString: list!.itemsString, sharedWithRef: [])
                                CKService.currentModel.createList(listModel: newListLocal) { result in
                                    switch result {
                                    case .success (let newListID):
                                        CKService.currentModel.saveListUsersList(listID: newListID, key: .MyLists) { result in
                                            presentSharedAlert = false
                                        }
                                    case .failure:
                                        presentSharedAlert = false
                                        return
                                    }
                                }
                            }
                          )
                    )
                }
            }
            .accentColor(Color("Link"))
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(listsViewModel)
            .onAppear {
                loadData()
            }
        }
    }
    
    func loadData() {
        DispatchQueue.main.async {
            CKService.currentModel.refresh { error in }
        }
        
    }
    
    func handleDeepLink(_ deeplink: DeepLink) {
        guard let listID = deeplink.listID else { return }
        guard let option = deeplink.option else { return }
        
        
        CKService.currentModel.getList(listID: CKRecord.ID(recordName: listID)) { result in
            switch result {
            case .success(let list):
                self.list = list
                
                if option == "1" {
                    presentCollabAlert = true
                } else if option == "2" {
                    presentSharedAlert = true
                }
                
            case .failure:
                // mensagem de erro não rolou
                return
            }
            
        }
    }
}
