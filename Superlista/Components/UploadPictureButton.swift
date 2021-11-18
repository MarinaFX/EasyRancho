import Foundation
import SwiftUI

struct UploadPictureButton: View {
    
    var body: some View {
        GeometryReader { geometryReader in
            ZStack {
                Circle()
                    .strokeBorder(Color.blue.opacity(0.2), lineWidth: 1)
                    .background(Circle().fill(Color.blue.opacity(0.15)))
                
                Image(systemName: "photo.on.rectangle")
                    .foregroundColor(Color("Button"))
                    .font(.system(size: geometryReader.size.height > geometryReader.size.width ? geometryReader.size.width * 0.4: geometryReader.size.height * 0.4))
                    .accessibilityHidden(true)
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

