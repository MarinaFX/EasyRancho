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
    @StateObject var listsViewModel: ListsViewModel = ListsViewModel()
    
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
                let d = DispatchSemaphore(value: 1)
                d.wait()
                loadData()
                d.signal()
                d.wait()
                CKServices.currentModel.updateUserName(name: "Gabriela") { result in }
                d.signal()
            }
        }
    }
    
    func loadData() {
        DispatchQueue.main.async {
            CKServices.currentModel.refresh { error in }
        }
        
    }
    
    func handleDeepLink(_ deeplink: DeepLink) {
        guard let ownerID = deeplink.ownerID else { return }
        guard let listID = deeplink.listID else { return }
        
        var ownerName: String?
        var listName: String?
        
        CKServices.currentModel.getAnotherUserName(userID: CKRecord.ID(recordName: ownerID)) { result in
            switch result {
                case .success(let name):
                ownerName = name
                print(ownerName)
                case .failure:
                    // mensagem de erro não rolou
                return
            }
        }
        
        CKServices.currentModel.getList(listID: CKRecord.ID(recordName: listID)) { result in
            switch result {
                case .success(let list):
                listName = list.name
                print(listName)
                // alerta para confirmar se quer adicionar nas listas do usuário passando como parâmetro o nome do usuário e da lista
                CKServices.currentModel.saveListUsersList(listID: list.id, key: "SharedWithMe") { result in
                        // mensagem de uhuu lista adicionada
                    }
            case .failure:
                // mensagem de erro não rolou
                return
            }
            
        }
    }
}
