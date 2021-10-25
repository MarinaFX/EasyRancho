//
//  TextFieldStyle.swift
//  Superlista
//
//  Created by Thaís Fernandes on 24/10/21.
//

import Foundation
import SwiftUI

struct CustomTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .padding(20)
            .foregroundColor(.black)
            .background(Color("ButtonBG"))
            .cornerRadius(15)
            .overlay(RoundedRectangle(cornerRadius: 10.0)
            .strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 1.0)))
            .padding(20)
    }
}
