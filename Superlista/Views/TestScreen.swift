//
//  TestScreen.swift
//  Superlista
//
//  Created by Marina De Pazzi on 11/05/21.
//

import SwiftUI

struct TestScreen: View {
    @State var items: [ItemModel] =
        [
            ItemModel(id: "599", product: ProductModel(id: 599, name: "Flemis food", category: "Flemis cookie"), comment: "Flemisflemis", isCompleted: true),
            ItemModel(id: "600", product: ProductModel(id: 600, name: "Flemis drink", category: "Flemis drink"), comment: "Flemisflemis", isCompleted: true),
            ItemModel(id: "601", product: ProductModel(id: 601, name: "Flemis veggie", category: "Flemis vegetables"), comment: "Flemisflemis", isCompleted: true),
            ItemModel(id: "602", product: ProductModel(id: 602, name: "Flemis oil", category: "Flemis oils"), comment: "Flemisflemis", isCompleted: true)
        ]
    
    var body: some View {
        NavigationLink(
            destination: MainView(),
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
