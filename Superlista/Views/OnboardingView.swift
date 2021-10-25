import SwiftUI


struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var currentColor: Color = onboardingPages[0].color
    
    init() {
        UIScrollView.appearance().bounces = false
    }
    
    func changeColor(value: Int) {
        withAnimation(.easeIn(duration: 0.1)) {
            currentColor = onboardingPages[value].color
        }
    }
    
    var body: some View {
        ZStack {
            currentColor.ignoresSafeArea()
            
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingPages.count) { i in
                        OnboardingPageView(index: i)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .onChange(of: currentPage, perform: changeColor)
                
                NavigationLink("Começar", destination: OnboardingFields())
                    .buttonStyle(MediumButtonStyle(background: .white, foreground: currentColor))
                    .padding(.top)
                    .padding(.bottom, 48)
            }
        }
        .foregroundColor(.white)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct OnboardingPageView: View {
    let index: Int
    
    var body: some View {
        VStack {
            Image(onboardingPages[index].image)
                .frame(width: UIScreen.main.bounds.width, height: 260)
                .padding(.bottom, 56)
            
            Text(onboardingPages[index].title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            
            Text(onboardingPages[index].text)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 27)
                .padding(.top, 12)
        }
        .tag(index)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

