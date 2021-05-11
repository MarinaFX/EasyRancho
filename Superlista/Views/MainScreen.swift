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
    
    var body: some View {
        ZStack{
            headerColor
                .ignoresSafeArea()
            
            VStack{
                customView
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(30)
            .padding(.bottom, -80)
            
            
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            MainScreen(customView: AnyView(ListView()))
                .navigationTitle("Adicionar Capa")
        }
        .accentColor(.white)
      
    }
}
