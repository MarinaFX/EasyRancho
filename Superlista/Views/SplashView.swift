import SwiftUI

struct SplashView: View {
    @EnvironmentObject var dataService: DataService
    
    var isActive: Bool {
        return dataService.user != nil
    }
    
    var isLogged: Bool {
        return dataService.user?.name != nil
    }
    
    var body: some View {
        VStack {
            if self.isActive && self.isLogged {
                MainView()
                
            } else if !self.isLogged {
                OnboardingView()
                
            } else {
                VStack {
                    Spacer()
                    
                    Image("DefaultLS")
                        .resizable()
                        .ignoresSafeArea()
                        .scaledToFill()
                    
                    Spacer()
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
