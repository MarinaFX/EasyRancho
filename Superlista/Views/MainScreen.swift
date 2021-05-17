//
//  MainScreen.swift
//  Superlista
//
//  Created by Gabriela Zorzo on 06/05/21.
//

import SwiftUI

struct MainScreen: View {
    
    var customView: AnyView?
    let headerColor = Color("HeaderColor")
    
    let background = Color("background")
    
    var body: some View {
        ZStack{
            headerColor
                .edgesIgnoringSafeArea(.top)
            
            VStack{
                customView.padding(.vertical)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(background)
            .foregroundColor(.black)
            .cornerRadius(30)
            .padding(.bottom, -80)
        }
        .padding(.bottom)
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
