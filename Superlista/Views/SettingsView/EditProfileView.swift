//
//  EditProfileView.swift
//  Superlista
//
//  Created by Luiz Eduardo Mello dos Reis on 20/10/21.
//

import SwiftUI

struct EditProfileView: View {
    @Binding var showingSheet: Bool
    @State private var newUsername = ""
    @State private var isShowGallery = false
    @Binding var username: String
    @Binding var picture: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Editar Perfil")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                ZStack {
                    if let picture = picture {
                        Image(uiImage: picture)
                            .resizable()
                            .clipShape(Circle())
                            .scaledToFill()
                            .frame(width:140, height: 140)
                    }
                    else {
                        if let newusername = newUsername{
                            ProfilePicture(username: newusername.isEmpty || newusername == "" ? username : newusername)
                                .padding()
                        }
                    }
                    Button{
                        self.isShowGallery = true
                    } label: {
                        ZStack{
                            Circle()
                                .stroke()
                                .frame(width: 140, height: 140)
                                .foregroundColor(.white)
                        }
                    }
                    .sheet(isPresented: $isShowGallery) {
                        ImagePicker(image: self.$picture)
                    }
                }
                TextField("Nome", text: $newUsername)
                    .modifier(CustomTextFieldStyle())

                
                Text("Adicione um nome e uma foto ao seu perfil para que você possa se identificado mais facilmente quando compartilhar ou for adicionado à uma lista.")
                    .padding(.horizontal)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.showingSheet = false
                    } label: {
                        Text("Cancelar")
                    }
                    
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if newUsername.isEmpty{
                            self.newUsername = CKService.currentModel.user?.name ?? ""
                        }
                        guard let picture = picture else {return}
                        CKService.currentModel.updateUserImageAndName(image: picture, name: newUsername) { result in}
                        self.username = newUsername
                        self.picture = picture
                        self.showingSheet = false
                    } label: {
                        Text("Salvar")
                    }
                }
            }
        }
    }
}