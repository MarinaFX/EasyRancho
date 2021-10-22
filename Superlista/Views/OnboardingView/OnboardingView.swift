import SwiftUI

struct OnboardingView: View {
    @State private var selected = 0
    @State private var backgroundColor = Color("HeaderColor")
    
    var currentColor: Color {
        return onboardingPages[selected].color
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                
                currentColor.ignoresSafeArea()
                
                VStack {
                    
                    TabView(selection: $selected) {
                        
                        ForEach(onboardingPages.indices, id: \.self) { index in
                            OnboardingPage(page: onboardingPages[index])
                                .padding(.bottom, 47)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .onChange(of: selected, perform: { value in
                        withAnimation {
                            backgroundColor = currentColor
                        }
                    })
                    
                    Spacer()
                    
                    MediumButton(text: "Começar", backgroundColor: .white, foregroundColor: currentColor)
                    
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationBarHidden(true)
                .padding(.bottom, 47)
            }
        }
    }
}
