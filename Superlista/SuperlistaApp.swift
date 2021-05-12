//
//  SuperlistaApp.swift
//  Superlista
//
//  Created by Marina De Pazzi on 30/04/21.
//

import SwiftUI

@main
struct SuperlistaApp: App {
    @StateObject var listsViewModel: ListsViewModel = ListsViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView()
            }
            .environmentObject(listsViewModel)
        }
    }
}
