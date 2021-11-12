import Foundation
import SwiftUI

struct MediumButtonStyle: ButtonStyle {
    @Environment(\.sizeCategory) var sizeCategory
    @ScaledMetric var buttonWidth: CGFloat = 150
    
    let backgroundColor: Color?
    let foregroundColor: Color?
    
    init(background: Color = .white, foreground: Color = .black, buttonWidth: CGFloat = 150) {
        self.backgroundColor = background
        self.foregroundColor = foreground
        self._buttonWidth = ScaledMetric.init(wrappedValue: buttonWidth)
    }
     
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .frame(minWidth: 150)
            .padding(.vertical, 14)
            .padding(.horizontal, sizeCategory.isAccessibilityCategory ? 32 : 0)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(sizeCategory.isAccessibilityCategory ? 20.0 : 14.0)
    }
}
