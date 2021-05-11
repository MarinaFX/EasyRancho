//
//  SuperlistaApp.swift
//  Superlista
//
//  Created by Marina De Pazzi on 30/04/21.
//

import SwiftUI

@main
struct SuperlistaApp: App {
    @StateObject var listViewModel: ListViewModel = ListViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                AddNewItemView(searchText: "")
            }
            .accentColor(.red)
            .environmentObject(listViewModel)
        }
    }
}
