//
//  SettingLabel.swift
//  Superlista
//
//  Created by Luiz Eduardo Mello dos Reis on 19/10/21.
//

import SwiftUI

struct SettingLabel: View {
    @Environment(\.sizeCategory) var sizeCategory
        
    @Binding var username: String
    @Binding var picture: UIImage?
    @State var showingSheet = false
    
    private var axes: Axis.Set {
        return sizeCategory.isAccessibilityCategory ? .vertical : []
    }
    
    var body: some View {
        ScrollView(axes, showsIndicators: false) {
            VStack(spacing: sizeCategory.isAccessibilityCategory ? 20 : 10){
                
                Button(action: {
                    showingSheet = true
                }) {
                    HStack {
                        Text("SettingLabelA")
                            .font(.body)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Image(systemName: "pencil.circle.fill")
                            .foregroundColor(.primary)
                            .font(.title3)
                    }
                    .padding(20)
                    .foregroundColor(.white)
                    .background(Color("ButtonBG"))
                    .cornerRadius(13)
                }
                .sheet(isPresented: $showingSheet) {
                    EditProfileView(showingSheet: $showingSheet, username: $username, picture: $picture)
                }
                
                // Premium desativado temporariamente
                //            Button(action: {
                //                print("Button tapped!")
                //            }) {
                //                HStack {
                //                    Text("Premium")
                //                        .font(.body)
                //                        .foregroundColor(.primary)
                //
                //                    Spacer()
                //
                //                    Image(systemName: "crown.fill")
                //                        .foregroundColor(.primary)
                //                        .font(.system(size: 20.0, weight: .bold))
                //                }
                //                .padding(20)
                //                .foregroundColor(.white)
                //                .background(Color("ButtonBG"))
                //                .cornerRadius(13)
                //            }
                
                Button(action: {
                    guard let instagram = URL(string: "https://www.instagram.com/easyrancho") else { return }
                    UIApplication.shared.open(instagram)
                }) {
                    HStack {
                        Text("SettingLabelB")
                            .font(.body)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Image(systemName: "ellipsis.bubble.fill")
                            .foregroundColor(.primary)
                            .font(.title3)
                    }
                    .padding(20)
                    .foregroundColor(.white)
                    .background(Color("ButtonBG"))
                    .cornerRadius(13)
                }
                
                Button(action: {
                    //Tá dando varias mensagens de 'erro' mas nada que se preocupar por enquanto #pas
                    guard let urlShare = URL(string: "https://apps.apple.com/br/app/easyrancho-lista-de-compras/id1568546773") else { return }
                    let activityVC = UIActivityViewController(activityItems: [NSLocalizedString("InviteMessage", comment: "InviteMessage"), urlShare], applicationActivities: nil)
                    UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
                    
                }) {
                    HStack {
                        Text("SettingLabelC")
                            .font(.body)
                            .foregroundColor(.primary)

                        Spacer()
                        
                        Image(systemName: "bolt.heart.fill")
                            .foregroundColor(.primary)
                            .font(.title3)
                    }
                    .padding(20)
                    .foregroundColor(.white)
                    .background(Color("ButtonBG"))
                    .cornerRadius(13)
                }
            }
        }
    }
}
