//
//  ProfileHeader.swift
//  Superlista
//
//  Created by Luiz Eduardo Mello dos Reis on 19/10/21.
//

import SwiftUI

struct ProfileHeader: View {
    var username: String
    var picture = UIImage()
    var body: some View {
        ZStack{
            VStack{
                Wave()
                    .fill(Color("HeaderBG"))
                    .frame(height: 205)
                    .padding(.horizontal, -30)
            }
            VStack{
                if((CKService.currentModel.user?.image) != nil){
                    Image(uiImage: picture)
                        .resizable()
                        .frame(width:140, height: 140)
                        .clipShape(Circle())
                    
                }
                else{
                    ProfilePicture(username: username)
                        .padding(.top, 100)
                }
            }
        }
        .ignoresSafeArea()
    }
}
