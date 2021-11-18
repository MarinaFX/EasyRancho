//
//  SettingsView.swift
//  Superlista
//
//  Created by Luiz Eduardo Mello dos Reis on 19/10/21.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var dataService: DataService
    
    @Binding var isOpened: Bool
    @State var username = getNickname()
    @State var picture: UIImage? = CKService.currentModel.user?.image
    
    func getUsername() {
        if let user = dataService.user,
           let name = user.name {
            self.username = name
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ProfileHeader(username: username, picture: picture)
                    .padding(.top, -30)
                
                Text(username)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)
                    .accessibilityHint("SettingsViewNameHint")
                
                // Premium desativado temporariamente
                //            HStack {
                //                Image(systemName: "crown.fill")
                //                    .foregroundColor(Color("Button"))
                //                Text("Premium")
                //                    .foregroundColor(.primary)
                //            }
                //            .padding(.bottom, 35)
                
                SettingLabel(username: $username, picture: $picture)
                    .padding(.horizontal, 15)
                
                Spacer()
            }
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.isOpened = false
                    } label: {
                        Text("Ok")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(Color.primary)
                            .accessibilityHint("SettingsViewToolbarTrailingHint")
                    }
                }
            }
        }
        .onAppear {
            getUsername()
        }
    }
}
