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
                ListByCategoryView(categoryName: "Matinais", list: listsViewModel.list[0])
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .accentColor(.red)
            .environmentObject(listsViewModel)
        }
    }
}
