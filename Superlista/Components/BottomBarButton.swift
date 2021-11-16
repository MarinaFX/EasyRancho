//
//  BottomBarButton.swift
//  Superlista
//
//  Created by Marina De Pazzi on 10/11/21.
//

import Foundation
import SwiftUI

struct BottomBarButton: View {
    @ScaledMetric var buttonHeight: CGFloat = 83
    
    public var action: (() -> Void)?
    var text: String
    
    init(action: @escaping(() -> Void), text: String, buttonHeight: CGFloat = 83) {
        self.action = action
        self.text = text
        self._buttonHeight = ScaledMetric.init(wrappedValue: buttonHeight)
    }
    
    
    var body: some View {
        Button(action: buttonAction) {
            VStack(alignment: .trailing) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                    
                    Text(NSLocalizedString(text, comment: ""))
                        .fontWeight(.bold)
                        .font(.title3)

                    Spacer()
                }
                .foregroundColor(Color("Button"))
                .padding(.bottom, 34)
                .padding(.horizontal, 14)
                .padding(.top, 18)
                
            }
            .frame(width: UIScreen.main.bounds.width, height: buttonHeight)
            .background(Color("ButtonBG"))
            .overlay(
                Rectangle()
                    .fill(Color(UIColor.systemGray5))
                    .frame(width: UIScreen.main.bounds.width, height: 1), alignment: .top
            )
        }
    }
    
    func buttonAction() {
        self.action?()
    }
}
