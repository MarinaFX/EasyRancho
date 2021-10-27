import SwiftUI
import UIKit
import CloudKit

@main
struct SuperlistaApp: App {
    @StateObject var dataService: DataService = DataService()
    
    let purpleColor = Color("Background")
    
    init() {
        UITableView.appearance().backgroundColor = UIColor(named: "PrimaryBackground")
    }
    
    @State var list: CKListModel?
    
    @State var presentCollabAlert: Bool = false
    @State var presentSharedAlert: Bool = false
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ZStack {
                    SplashView()
                        .onOpenURL(perform: { url in
                            guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
                                  let host = components.host else {
                                      print("Invalid URL")
                                      return
                                  }
                            
                            let deepLink = DeepLink(id: host)
                            
                            handleDeepLink(deepLink)
                            
                        })
                    ZStack {
                        
                    }
                    .alert(isPresented: $presentCollabAlert) {
                        return Alert(
                            title: Text(list?.name ?? "NovaLista"),
                            message: Text("CollabAlerta"),
                            primaryButton:  .default(
                                Text("Cancelar"),
                                action: {
                                    presentCollabAlert = false
                                }),
                            secondaryButton: .default(
                                Text("Aceitar"),
                                action: {
                                    CKService.currentModel.saveListUsersList(listID: list!.id, key: .SharedWithMe) { result in }
                                    let user = CKOwnerModel(id: CKService.currentModel.user!.id, name: CKService.currentModel.user!.name!)
                                    var sharedWith = list!.sharedWith
                                    for user in sharedWith {
                                        print(user.id.recordName, "shared with")
                                    }
                                    sharedWith.append(user)
                                    CKService.currentModel.updateListCollab(listID: list!.id, sharedWith: sharedWith) { result in }
                                    presentCollabAlert = false
                                }
                            )
                        )
                    }
                    ZStack {
                        
                    }
                    .alert(isPresented: $presentSharedAlert) {
                        return Alert(title: Text(list?.name ?? "NovaLista"),
                                     message: Text("SharedAlerta"),
                                     primaryButton: .default(
                                        Text("Cancelar"), action: {
                                            presentSharedAlert = false
                                        }),
                                     secondaryButton: .default(
                                        Text(NSLocalizedString("Aceitar", comment: "")),
                                        action: {
                                            let newOwnerRef = CKRecord.Reference(recordID: CKService.currentModel.user!.id, action: .none)
                                            let newListLocal = CKListModel(name: list!.name ?? "NovaLista", ownerRef: newOwnerRef, itemsString: list!.itemsString)
                                            CKService.currentModel.createList(listModel: newListLocal) { result in
                                                switch result {
                                                case .success (let newListID):
                                                    CKService.currentModel.saveListUsersList(listID: newListID, key: .MyLists) { result in }
                                                case .failure:
                                                    return
                                                }
                                                presentSharedAlert = false
                                            }
                                        }
                                     )
                        )
                    }
                }
            }
            .accentColor(Color("Link"))
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(dataService)
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
                
                /* alerta para confirmar se quer adicionar nas listas do usuário passando como parâmetro o nome do usuário e da lista */
                
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
