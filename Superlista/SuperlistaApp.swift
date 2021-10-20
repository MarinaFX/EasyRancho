//
//  SuperlistaApp.swift
//  Superlista
//
//  Created by Marina De Pazzi on 30/04/21.
//

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
            .accentColor(Color("Link"))
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(listsViewModel)
            .onAppear {

                loadData()
              //  shareSheet(listID: "F77D5AC4-0826-FDED-6A4B-9149525797BB", ownerID: "_1143797df206f7c3a1c63e674e238bf7", option: "1", listName: "Lista teste", ownerName: "Gabi Zorzo")

            }
        }
    }
    
    func loadData() {
        DispatchQueue.main.async {
            CKService.currentModel.refresh { error in }
        }
        
    }
    
    func handleDeepLink(_ deeplink: DeepLink) {
        guard let ownerID = deeplink.ownerID else { return }
        guard let listID = deeplink.listID else { return }
        guard let option = deeplink.option else { return }
        
        var ownerName: String?
        var listName: String?
        
        CKService.currentModel.getAnotherUserName(userID: CKRecord.ID(recordName: ownerID)) { result in
            switch result {
                case .success(let name):
                ownerName = name
                case .failure:
                    // mensagem de erro não rolou
                return
            }
        }
        
        CKService.currentModel.getList(listID: CKRecord.ID(recordName: listID)) { result in
            switch result {
                case .success(let list):
                listName = list.name
                // alerta para confirmar se quer adicionar nas listas do usuário passando como parâmetro o nome do usuário e da lista
                if option == "1" {
                    CKService.currentModel.saveListUsersList(listID: list.id, key: .SharedWithMe) { result in
                        // mensagem de uhuu lista adicionada
                        print(result)
                    }
                } else if option == "2" {
                    let newListLocal = CKListModel(name: listName!, itemsString: list.itemsString)
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
