import SwiftUI
import UIKit
import CloudKit

@main
struct SuperlistaApp: App {
    @StateObject var listsViewModel: DataService = DataService()
    
    let purpleColor = Color("HeaderColor")
    
    init() {
        UITableView.appearance().backgroundColor = UIColor(named: "background")
    }
    
    @State var list: CKListModel?
    
    @State var presentCollabAlert: Bool = false
    
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
                }
                .alert(isPresented: $presentCollabAlert) {
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
                                CKService.currentModel.saveListUsersList(listID: list!.id, key: .SharedWithMe) { result in }
                                let user = CKOwnerModel(id: CKService.currentModel.user!.id, name: CKService.currentModel.user!.name!)
                                var sharedWith = list!.sharedWith
                                sharedWith.append(user)
                                CKService.currentModel.updateListCollab(listID: list!.id, sharedWith: sharedWith) { result in }
                                presentCollabAlert = false
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
        
        var listName: String?
        
        CKService.currentModel.getList(listID: CKRecord.ID(recordName: listID)) { result in
            switch result {
            case .success(let list):
                self.list = list
                
                /* alerta para confirmar se quer adicionar nas listas do usuário passando como parâmetro o nome do usuário e da lista */
                
                if option == "1" {
                    presentCollabAlert = true
                } else if option == "2" {
                    let newListLocal = CKListModel(name: listName!, ownerRef: list.ownerRef, itemsString: list.itemsString)
                    CKService.currentModel.createList(listModel: newListLocal) { result in
                        switch result {
                        case .success (let newListID):
                            CKService.currentModel.saveListUsersList(listID: newListID, key: .MyLists) { result in
                                // mensagem de uhuu lista adicionada
                            }
                        case .failure:
                            // mensagem de erro não rolou
                            return
                        }
                    }
                }
            case .failure:
                // mensagem de erro não rolou
                return
            }
            
        }
    }
}
