import SwiftUI

struct MainScreen<Content: View>: View {
    var customView: Content?
    
    var height: CGFloat = .infinity
    var bottomPadding: CGFloat = -35
    var topPadding: CGFloat = 0
    
    let headerColor = Color("Background")
    
    var body: some View {
        ZStack() {
            headerColor
                .edgesIgnoringSafeArea(.top)
                
            
            VStack {
                customView
                    .padding(.vertical)
            }
            .frame(maxWidth: .infinity, maxHeight: height) 
            .background(Color("PrimaryBackground"))
            .foregroundColor(.black)
            .cornerRadius(30)
            .padding(.bottom, bottomPadding)
            .padding(.top, topPadding)
        }
    }
}
