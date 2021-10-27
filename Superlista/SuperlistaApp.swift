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
                listName = list.name
                    
                /* alerta para confirmar se quer adicionar nas listas do usuário passando como parâmetro o nome do usuário e da lista */
                    
                if option == "1" {
                    CKService.currentModel.saveListUsersList(listID: list.id, key: .SharedWithMe) { result in
                        // mensagem de uhuu lista adicionada
                        print(result)
                    }
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
