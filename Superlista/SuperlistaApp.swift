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
    
    @State var isFirstAppear: Bool = true
    
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
#warning("Pensar em como bloquear o usuário de receber uma lista compartilhada caso ele esteja offline")
                                    guard let list = list else { return }
                                    dataService.addCollabList(of: list)
                                    
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
                                            guard let list = list else { return }
                                            let newList = ListModelConverter().convertCloudListToLocal(withList: list)
                                            dataService.duplicateList(of: newList)
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
                guard isFirstAppear else { return }
                isFirstAppear = false
                NetworkMonitor.shared.startMonitoring { path in
                    print(path.status, "status on appear")
                    if path.status == .satisfied {
                        if CKService.currentModel.user != nil {
                            dataService.refreshUser()
                        } else {
                            loadData()
                        }
                    }
                }
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
