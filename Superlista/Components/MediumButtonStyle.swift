import Foundation
import SwiftUI

struct MediumButtonStyle: ButtonStyle {
    
    let backgroundColor: Color?
    let foregroundColor: Color?
    
    init(background: Color, foreground: Color) {
        self.backgroundColor = background
        self.foregroundColor = foreground
    }
    
    init() {
        self.backgroundColor = .white
        self.foregroundColor = .black
    }
     
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .frame(minWidth: 150)
            .padding(.vertical, 14)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(14.0)
    }
}
