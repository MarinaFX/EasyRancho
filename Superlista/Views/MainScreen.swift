//
//  MainScreen.swift
//  Superlista
//
//  Created by Gabriela Zorzo on 06/05/21.
//

import SwiftUI

struct MainScreen: View {
    var customView: AnyView?
    
    var height: CGFloat = .infinity
    var bottomPadding: CGFloat = -80
    var topPadding: CGFloat = 0
    
    let headerColor = Color("HeaderColor")
    let background = Color("background")
    
    var body: some View {
        ZStack() {
            headerColor
                .edgesIgnoringSafeArea(.top)
                
            
            VStack {
                customView
                    .padding(.vertical)
            }
            .frame(maxWidth: .infinity, maxHeight: height) 
            .background(background)
            .foregroundColor(.black)
            .cornerRadius(30)
            .padding(.bottom, bottomPadding)
            .padding(.top, topPadding)
        }
    }
}

//struct MainScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView{
//            AddNewItemView(searchText: "")
//                //.navigationTitle("Adicionar Capa")
//        }
//        .accentColor(.white)
//      
//    }
//}
