//
//  ProfileHeader.swift
//  Superlista
//
//  Created by Luiz Eduardo Mello dos Reis on 19/10/21.
//

import SwiftUI

struct ProfileHeader: View {
    var body: some View {
        ZStack{
            VStack{
                Wave()
                    .fill(Color("HeaderBG"))
                    .frame(height: 205)
                    .padding(.horizontal, -30)
            }
            VStack{
                //if
                ProfilePicture(nameUser: "Luiz")
                    .padding(.top, 100)
            }
        }
        .ignoresSafeArea()
    }
}

struct ProfileHeader_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeader()
    }
}
