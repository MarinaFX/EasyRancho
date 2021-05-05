//
//  SuperlistaApp.swift
//  Superlista
//
//  Created by Marina De Pazzi on 30/04/21.
//

import SwiftUI

@main
struct SuperlistaApp: App {
    @StateObject var productListViewModel: ProductListViewModel = ProductListViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .environmentObject(productListViewModel)
        }
    }
}
