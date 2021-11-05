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
    
    let newListLocalizedLabel = NSLocalizedString("NovaLista", comment: "NovaLista")
    
    var body: some Scene {
        WindowGroup {
            VStack {
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
                            title: Text(list?.name ?? newListLocalizedLabel),
                            message: Text("CollabAlertText"),
                            primaryButton:  .default(
                                Text("AlertPrimaryButtonLabel"),
                                action: {
                                    presentCollabAlert = false
                                }),
                            secondaryButton: .default(
                                Text("AlertSecondaryButtonLabel"),
                                action: {
                                    CKService.currentModel.saveListUsersList(listID: list!.id, key: .SharedWithMe) { result in }
                                    let user = CKOwnerModel(id: CKService.currentModel.user!.id, name: CKService.currentModel.user!.name!)
                                    var sharedWith = list!.sharedWith
                                    for user in sharedWith {
                                        print(user.id.recordName, "shared with")
                                    }
                                    sharedWith.append(user)
                                    CKService.currentModel.updateListCollab(listID: list!.id, sharedWith: sharedWith) { result in }
                                    
                                    //Início da gambiarra
                                    list?.sharedWith = sharedWith
                                    let localList = ListModelConverter().convertCloudListToLocal(withList: list!)
                                    self.dataService.lists.append(localList)
                                    //Fim da gambiarra
                                    
                                    presentCollabAlert = false
                                }
                            )
                        )
                    }
                    ZStack {
                        
                    }
                    .alert(isPresented: $presentSharedAlert) {
                        return Alert(title: Text(list?.name ?? newListLocalizedLabel),
                                     message: Text("SharedAlertText"),
                                     primaryButton: .default(
                                        Text("AlertPrimaryButtonLabel"), action: {
                                            presentSharedAlert = false
                                        }),
                                     secondaryButton: .default(
                                        Text(NSLocalizedString("AlertSecondaryButtonLabel", comment: "")),
                                        action: {
                                            let ckList = ListModelConverter().convertCloudListToLocal(withList: list!)
                                            dataService.duplicateList(of: ckList)
                                            presentSharedAlert = false
                                        }
                                     )
                        )
                    }
                }
            }
            .accentColor(Color("Link"))
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
