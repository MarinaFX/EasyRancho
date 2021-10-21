//
//  SettingsView.swift
//  Superlista
//
//  Created by Luiz Eduardo Mello dos Reis on 19/10/21.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack{
            ProfileHeader()
                .padding(.top, -30)
            Text("Luiz Eduardo")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 10)
            
            HStack {
                Image(systemName: "crown.fill")
                    .foregroundColor(Color("Selected"))
                Text("Premium")
                    .foregroundColor(.primary)
            }
            .padding(.bottom, 35)
        
            SettingLabel()
                .padding(.horizontal, 15)
            Spacer()
        }
        .ignoresSafeArea()
    }   
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
