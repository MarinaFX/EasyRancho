import SwiftUI

struct SplashView: View {
    @State var isActive: Bool = false
    @State var isLogged: Bool = false
    
    var body: some View {
        VStack {
            if self.isActive {
                if isLogged {
                    MainView()
                } else {
                    OnboardingView() {
                        self.isLogged = CKService.currentModel.user?.name != nil
                    }
                }
            } else {
                VStack{
                    Spacer()
                    Image("DefaultLS")
                        .resizable()
                        .ignoresSafeArea()
                        .scaledToFill()
                    Spacer()
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                    
                    self.isLogged = CKService.currentModel.user?.name != nil
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
