import Foundation
import SwiftUI

struct MediumButton: View {
    var action: (() -> Void)?
    var text: String
    var backgroundColor: Color
    var foregroundColor: Color
    
    var body: some View {
        Button(action: {
            withAnimation {
                action?()
            }
        }, label: {
            HStack {
                Text(text)
            }
        })
        .frame(minWidth: 150)
        .padding(.vertical, 14)
        .padding(.horizontal, 30)
        .foregroundColor(foregroundColor)
        .background(backgroundColor)
        .cornerRadius(14.0)
    }
}
