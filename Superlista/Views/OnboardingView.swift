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
                            OnboardingTab(page: onboardingPages[index])
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
                    
                    StartButton(foregroundColor: currentColor)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationBarHidden(true)
                .padding(.bottom, 47)
            }
        }
    }
}

struct StartButton: View {
    var foregroundColor: Color
    
    var body: some View {
        Button(action: {
            withAnimation {
                print("chama a modal")
            }
        }, label: {
            HStack {
                Text("Começar")
            }
        })
        .padding(.vertical, 14)
        .padding(.horizontal, 30)
        .foregroundColor(foregroundColor)
        .background(Color.white)
        .cornerRadius(14.0)
    }
}

struct OnboardingTab: View {
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
