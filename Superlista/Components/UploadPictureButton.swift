//
//  UploadPictureButton.swift
//  Superlista
//
//  Created by Thaís Fernandes on 24/10/21.
//

import Foundation
import SwiftUI

struct UploadPictureButton: View {
    
    var body: some View {
        GeometryReader { g in
            ZStack {
                Circle()
                    .strokeBorder(Color.blue.opacity(0.2), lineWidth: 1)
                    .background(Circle().fill(Color.blue.opacity(0.15)))
                    
                Image(systemName: "photo.on.rectangle")
                    .foregroundColor(.blue)
                    .font(.system(size: g.size.height > g.size.width ? g.size.width * 0.4: g.size.height * 0.4))
            }
        }
        .frame(width: 122, height: 122)
    }
}

struct UploadPictureButton_Previews: PreviewProvider {
    static var previews: some View {
        UploadPictureButton()
    }
}

