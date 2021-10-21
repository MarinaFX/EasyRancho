//
//  ProfilePicture.swift
//  Superlista
//
//  Created by Luiz Eduardo Mello dos Reis on 19/10/21.
//

import SwiftUI

struct ProfilePicture: View {
    var nameUser: String
    
    var body: some View {
        GeometryReader { g in
            ZStack {
                Color("Pronto")
                    .clipShape(Circle())
                Circle()
                    .stroke(Color.white, style: StrokeStyle(lineWidth: 5))
                    .frame(width: 140, height: 140)
                
                let initialName = nameUser.prefix(1)
                Text(String(initialName))
                    .foregroundColor(.white)
                    .font(.system(size: g.size.height > g.size.width ? g.size.width * 0.5: g.size.height * 0.5))
                
            }
        }
        .frame(width: 160, height: 160)
    }
}

struct ProfilePicture_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePicture(nameUser: "Jorge")
            .previewLayout(.fixed(width: 160, height: 160))

    }
}
