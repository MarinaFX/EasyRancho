//
//  SettingLabel.swift
//  Superlista
//
//  Created by Luiz Eduardo Mello dos Reis on 19/10/21.
//

import SwiftUI

struct SettingLabel: View {
    @Binding var username: String
    @State var showingSheet = false
    @Binding var picture: UIImage?
    
    var body: some View {
        VStack(spacing: 10){
            Button(action: {
                showingSheet = true
            }) {
                HStack {
                    Text("EditarPerfilLabel")
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "pencil.circle.fill")
                        .foregroundColor(.primary)
                        .font(.system(size: 20.0, weight: .bold))
                }
                .padding(20)
                .foregroundColor(.white)
                .background(Color("ButtonBG"))
                .cornerRadius(13)
            }
            .sheet(isPresented: $showingSheet) {
                EditProfileView(showingSheet: $showingSheet, username: $username, picture: $picture)
            }
            
#warning("Premium desativado temporariamente")
            //            Button(action: {
            //                print("Button tapped!")
            //            }) {
            //                HStack {
            //                    Text("Premium")
            //                        .foregroundColor(.primary)
            //                    Spacer()
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
                    Text("ContatoLabel")
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "ellipsis.bubble.fill")
                        .foregroundColor(.primary)
                        .font(.system(size: 20.0, weight: .bold))
                }
                .padding(20)
                .foregroundColor(.white)
                .background(Color("ButtonBG"))
                .cornerRadius(13)
            }
            Button(action: {
                #warning("Tá dando varias mensagens de 'erro' mas nada que se preocupar por enquanto #pas ")
                guard let urlShare = URL(string: "https://apps.apple.com/br/app/easyrancho-lista-de-compras/id1568546773") else { return }
                let activityVC = UIActivityViewController(activityItems: ["Veja o App que estou usando para fazer minhas listas de compras. Baixa vc também! =)", urlShare], applicationActivities: nil)
                UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
                
            }) {
                    HStack {
                        Text("ConvideUmAmigoLabel")
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "bolt.heart.fill")
                            .foregroundColor(.primary)
                            .font(.system(size: 20.0, weight: .bold))
                    }
                    .padding(20)
                    .foregroundColor(.white)
                    .background(Color("ButtonBG"))
                    .cornerRadius(13)
                }
        }
    }
}

//struct SettingLabel_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingLabel(username: "Luiz")
//    }
//}
