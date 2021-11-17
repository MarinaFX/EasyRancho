import Foundation
import SwiftUI

struct CustomTextFieldStyle: ViewModifier {
    let strokeColor: Color
    
    init(strokeColor: Color) {
        self.strokeColor = strokeColor
    }
    
    init() {
        self.strokeColor = Color.gray
    }
    
    func body(content: Content) -> some View {
        return content
            .padding(20)
            .foregroundColor(.primary)
            .background(Color("ButtonBG"))
            .cornerRadius(15)
            .overlay(RoundedRectangle(cornerRadius: 10.0)
            .strokeBorder(strokeColor, style: StrokeStyle(lineWidth: 1.0)))
            .padding(20)
    }
}
