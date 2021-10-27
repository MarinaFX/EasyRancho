//
//  ProfilePicture.swift
//  Superlista
//
//  Created by Luiz Eduardo Mello dos Reis on 19/10/21.
//

import SwiftUI

struct ProfilePicture: View {
    var username: String
    
    var body: some View {
        GeometryReader { geometryReader in
            ZStack {
                Color("Button")
                    .clipShape(Circle())
                
                Circle()
                    .stroke(Color.white, style: StrokeStyle(lineWidth: 5))
                    .frame(width: 140, height: 140)
                
                let initialName = username.prefix(1)
                Text(String(initialName))
                    .foregroundColor(.white)
                    .font(.system(size: geometryReader.size.height > geometryReader.size.width ? geometryReader.size.width * 0.5: geometryReader.size.height * 0.5))
                
            }
        }
        .frame(width: 160, height: 160)
    }
}
