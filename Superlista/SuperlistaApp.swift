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
                    }
                    .alert(isPresented: $presentCollabAlert) {
                        print("alert1")
                        return Alert(
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
//                                    let ds = DispatchSemaphore(value: 1)
//                                    ds.wait()
                                    CKService.currentModel.saveListUsersList(listID: list!.id, key: .SharedWithMe) { result in
//                                        ds.signal()
                                    }
//                                    ds.wait()
                                    let user = CKService.currentModel.user!
//                                    ds.signal()
//                                    ds.wait()
                                    var sharedWith = list!.sharedWith
//                                    ds.signal()
//                                    ds.wait()
                                    sharedWith.append(user)
//                                    ds.signal()
//                                    ds.wait()
                                    print(sharedWith)
                                    CKService.currentModel.updateListCollab(listID: list!.id, sharedWith: sharedWith) { result in
//                                        ds.signal()
                                        print(result, "result")
                                    }
//                                    ds.wait()
                                    presentCollabAlert = false
//                                    ds.signal()
                                }
                            )
                        )
                    }
                }
//              //  .alert(isPresented: $presentSharedAlert) {
//                    print("alert2")
//                    return Alert(title: Text(list?.name ?? "Lista"),
//                          message: Text("Esta lista foi compartilhada com você. Deseja adicionar uma cópia desta lista?"),
//                          primaryButton: .default(
//                            Text("Cancelar"), action: {
//                                presentSharedAlert = false
//                            }),
//                          secondaryButton: .default(
//                            Text("Aceitar"),
//                            action: {
//                                let ds = DispatchSemaphore(value: 1)
//                                ds.wait()
//                                let newOwnerRef = CKRecord.Reference(recordID: CKService.currentModel.user!.id, action: .none)
//                                let newListLocal = CKListModel(name: list!.name ?? "Nova Lista", ownerRef: newOwnerRef, itemsString: list!.itemsString, sharedWithRef: [])
//                                ds.signal()
//                                ds.wait()
//                                CKService.currentModel.createList(listModel: newListLocal) { result in
//                                    switch result {
//                                    case .success (let newListID):
//                                        ds.signal()
//                                        ds.wait()
//                                        CKService.currentModel.saveListUsersList(listID: newListID, key: .MyLists) { result in
//                                            presentSharedAlert = false
//                                            ds.signal()
//                                        }
//                                    case .failure:
//                                        presentSharedAlert = false
//                                        ds.signal()
//                                    }
//                                }
//                            }
//                          )
//                    )
//                }
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
        
        print(presentCollabAlert, "1")
        
        CKService.currentModel.getList(listID: CKRecord.ID(recordName: listID)) { result in
            switch result {
            case .success(let list):
                self.list = list
                print(list.sharedWith)
                if option == "1" {
                    presentCollabAlert = true
                    print(presentCollabAlert, "2")
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
