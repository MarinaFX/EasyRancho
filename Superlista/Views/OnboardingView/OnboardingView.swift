import SwiftUI

struct OnboardingView: View {
    var action: (() -> Void)?
    
    @State private var currentPage = 0
    @State private var currentColor: Color = onboardingPages[0].color
    @State private var picture: UIImage? = nil
    
    init(action: (() -> Void)?) {
        self.action = action
        UIScrollView.appearance().bounces = false
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
                
                NavigationLink("Começar", destination: OnboardingFieldsView(action: action, picture: $picture))
                    .buttonStyle(MediumButtonStyle(background: .white, foreground: currentColor))
                    .padding(.top)
                    .padding(.bottom, 48)
            }
        }
        .foregroundColor(.white)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    func changeColor(value: Int) {
        withAnimation(.easeIn(duration: 0.1)) {
            currentColor = onboardingPages[value].color
        }
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
        OnboardingView(action: {})
    }
}

