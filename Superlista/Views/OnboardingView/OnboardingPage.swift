import Foundation
import SwiftUI

struct OnboardingPage: View {
    let page: Page
    
    var body: some View {
        VStack {
            Image(page.image)
                .resizable()
                .scaledToFit()
                .padding(.horizontal)
            
            Spacer()
            
            Text(page.title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 12)
            
            Text(page.text)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 27)
            
            Spacer()
            
        }
        .foregroundColor(.white)
    }
}
