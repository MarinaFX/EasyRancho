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
                TabView{
                    MainView()
                        .tabItem {
                            Label("Listas", systemImage: "rectangle.grid.2x2.fill")
                        }
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                        .navigationBarTitleDisplayMode(.inline)
//                    ListView()
//                        .tabItem {
//                            Label("Nova Lista", systemImage: "plus.circle.fill")
//                        }
                    SettingsView()
                        .tabItem {
                            Label("Configurações", systemImage: "person.crop.circle.fill")
                        }
                }
                
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
