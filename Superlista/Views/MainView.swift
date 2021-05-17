//
//  MainView.swift
//  Superlista
//
//  Created by Thaís Fernandes on 12/05/21.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ListsView()
                .tabItem {
                    Image(systemName: "list.bullet.rectangle")
                }
            
            ListView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                }
            
            ListsView()
                .tabItem {
                    Image(systemName: "gearshape")
                }
        }
        .onAppear {
            UITabBar.appearance().isTranslucent = false
            UITabBar.appearance().barTintColor = UIColor(named: "TabbarColor")
        }
        .accentColor(.green)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
