import SwiftUI

struct SplashView: View {
    @State var isActive: Bool = false
    @State var isLogged: Bool = false
    @State var listId: String = ""
    
    var body: some View {
        VStack {
            if self.isActive {
                if isLogged {
                    TabView{
                        MainView()
                            .tabItem{
                                Label("Listas", systemImage: "rectangle.grid.2x2.fill")
                            }
//                            .navigationBarHidden(true)
//                            .navigationBarBackButtonHidden(true)
//                            .navigationBarTitleDisplayMode(.inline)

                        
                        ListView(listId: "")
                            .tabItem {
                                Label("Nova Lista", systemImage: "plus.circle.fill")
                            }
                        SettingsView()
                            .tabItem {
                                Label("Configurações", systemImage: "person.crop.circle.fill")
                            }
                    }
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation {
                    self.isActive = true
                    
                    self.isLogged = CKService.currentModel.user?.name == nil
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
