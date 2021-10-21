import SwiftUI

struct MainScreen: View {
    var customView: AnyView?
    
    var height: CGFloat = .infinity
    var bottomPadding: CGFloat = -35
    var topPadding: CGFloat = 0
    
    let headerColor = Color("HeaderColor")
    
    var body: some View {
        ZStack() {
            headerColor
                .edgesIgnoringSafeArea(.top)
                
            
            VStack {
                customView
                    .padding(.vertical)
            }
            .frame(maxWidth: .infinity, maxHeight: height) 
            .background(Color("background"))
            .foregroundColor(.black)
            .cornerRadius(30)
            .padding(.bottom, bottomPadding)
            .padding(.top, topPadding)
        }
    }
}
