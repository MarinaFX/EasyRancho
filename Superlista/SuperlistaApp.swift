//
//  SuperlistaApp.swift
//  Superlista
//
//  Created by Marina De Pazzi on 30/04/21.
//

import SwiftUI
import UIKit

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
            }
            .accentColor(Color("Link"))
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(listsViewModel)
            .onAppear(perform: loadData)
        }
    }
    
    func loadData() {
        DispatchQueue.main.async {
            CKServices.currentModel.refresh { error in }
        }
    }

}
