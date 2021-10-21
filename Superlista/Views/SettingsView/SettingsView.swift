//
//  SettingsView.swift
//  Superlista
//
//  Created by Luiz Eduardo Mello dos Reis on 19/10/21.
//

import SwiftUI

struct SettingsView: View {
    @State var username = CKService.currentModel.user?.name ?? getNickname()
    var body: some View {
        VStack{
            ProfileHeader(username: username)
                .padding(.top, -30)
            Text(username)
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
        
            SettingLabel(username: username)
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
