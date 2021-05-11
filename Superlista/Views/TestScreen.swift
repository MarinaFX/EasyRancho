//
//  TestScreen.swift
//  Superlista
//
//  Created by Marina De Pazzi on 11/05/21.
//

import SwiftUI

struct TestScreen: View {
    var body: some View {
        NavigationLink(
            destination: GridListView(items: <#Binding<[ItemModel]>#>, currentItem: <#Binding<ItemModel?>#>),
            label: {
                Text("Navigate")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(height: 40)
                    .frame(width: 165)
                    .background(Color.orange)
                    .cornerRadius(30)
                    .shadow(radius: 10)
            })
    }
}


struct TestScreen_Previews: PreviewProvider {
    static var previews: some View {
        TestScreen()
    }
}
