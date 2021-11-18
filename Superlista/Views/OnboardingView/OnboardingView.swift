import SwiftUI

struct OnboardingView: View {
    @Environment(\.sizeCategory) var sizeCategory
    
    @State private var currentPage = 0
    @State private var currentColor: Color = onboardingPages[0].color
    @State private var picture: UIImage? = nil
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    init() {
        UIScrollView.appearance().bounces = false
        print(height)
    }
    
    var paddingProportion: Double {
        if sizeCategory > .large {
            return 0.1
        }
        return 1
    }
    
    var body: some View {
        NavigationView {
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
                    .accessibilityHint("Marcação da página atual")
                    
                    NavigationLink("OnboardingViewButtonLabel", destination: OnboardingFieldsView(picture: $picture))
                        .buttonStyle(MediumButtonStyle(background: .white, foreground: currentColor))
                        .padding(.top)
                        .padding(.bottom, 48 * paddingProportion)
                }
            }
            .foregroundColor(.white)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
    
    func changeColor(value: Int) {
        withAnimation(.easeIn(duration: 0.1)) {
            currentColor = onboardingPages[value].color
        }
    }
}

struct OnboardingPageView: View {
    @Environment(\.sizeCategory) var sizeCategory
    
    let index: Int
    
    let height = UIScreen.main.bounds.height
    let width = UIScreen.main.bounds.width
    
    @ScaledMetric var scaledImage: CGFloat = ((260*UIScreen.main.bounds.height)/844)
    @ScaledMetric var scaledImagePadding: CGFloat = ((56*UIScreen.main.bounds.height)/844)
    @ScaledMetric var textTopPadding: CGFloat = ((27*UIScreen.main.bounds.height)/844)
    @ScaledMetric var textBottomPadding: CGFloat = ((12*UIScreen.main.bounds.height)/844)

    var imgProportion: Double {
        switch sizeCategory {
            case .extraLarge:
                return 0.8
            case .extraExtraLarge:
                return 0.7
            case .extraExtraExtraLarge:
                return 0.6
            case .accessibilityMedium:
                return 0.5
            case .accessibilityLarge, .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
                return 0.4
            default:
                return 1
        }
    }
    
    var paddingProportion: Double {
        if sizeCategory > .large {
            return 0.1
        }
        return 1
    }
    
    func getProportion(varValue: Double) -> Double {
        return ((varValue * height)/844)
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            if sizeCategory < .accessibilityLarge {
                Image(onboardingPages[index].image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width * imgProportion, height: scaledImage * imgProportion)
                    .padding(.bottom, scaledImagePadding * paddingProportion)
                    .accessibilityLabel(onboardingPages[index].imageLabel)
                    .accessibilityHint(onboardingPages[index].imageHint)
            }
            
            Text(onboardingPages[index].title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(onboardingPages[index].text)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, textTopPadding * paddingProportion)
                .padding(.top, textBottomPadding * paddingProportion)
            
            Spacer()
        }
        .tag(index)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

