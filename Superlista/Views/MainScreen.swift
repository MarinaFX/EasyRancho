//
//  MainScreen.swift
//  Superlista
//
//  Created by Gabriela Zorzo on 06/05/21.
//

import SwiftUI

struct MainScreen: View {
    
    let headerColor = Color("HeaderColor")
    
    var body: some View {
        ZStack{
            headerColor
                .ignoresSafeArea()
            
            VStack{
                Text("Nova Lista")
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
            MainScreen()
                .navigationTitle("Adicionar Capa")
        }
        .accentColor(.white)
      
    }
}
