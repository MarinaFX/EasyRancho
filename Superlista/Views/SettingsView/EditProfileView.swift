//
//  EditProfileView.swift
//  Superlista
//
//  Created by Luiz Eduardo Mello dos Reis on 20/10/21.
//

import SwiftUI

struct EditProifleView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var newUsername: String = ""
    
    var body: some View {
        NavigationView {
            VStack{
                Text("Editar Perfil")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                ProfilePicture(nameUser: "Luiz")
                    .padding()
                TextField("Nome", text: $newUsername)
                    .padding(20)
                    .foregroundColor(.black)
                    .background(Color("ButtonBG"))
                    .cornerRadius(15)
                    .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 1.0)))
                    .padding(20)
                Text("Adicione um nome e uma foto ao seu perfil para que você possa se identificado mais facilmente quando compartilhar ou for adicionado à uma lista.")
                    .padding(.horizontal)
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
            }
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Salvar").bold()
            })
        }
    }
}

struct EditProifleView_Previews: PreviewProvider {
    static var previews: some View {
        EditProifleView()
        
    }
}
