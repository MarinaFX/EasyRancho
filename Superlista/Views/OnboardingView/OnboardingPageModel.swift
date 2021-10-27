import SwiftUI

struct OnboardingPage {
    let image: String
    let title: String
    let text: String
    let color: Color
}

let onboardingPages = [
    OnboardingPage(
        image: NSLocalizedString("OnboardingA", comment: ""),
        title: NSLocalizedString("OnboardingATitle", comment: ""),
        text: NSLocalizedString("OnboardingAText", comment: ""),
        color: Color("Background")
    ),
    OnboardingPage(
        image: NSLocalizedString("OnboardingB", comment: ""),
        title: NSLocalizedString("OnboardingBTitle", comment: ""),
        text: NSLocalizedString("OnboardingBText", comment: ""),
        color: Color("Higieneebeleza")
    ),
    OnboardingPage(
        image: NSLocalizedString("OnboardingC", comment: ""),
        title: NSLocalizedString("OnboardingCTitle", comment: ""),
        text: NSLocalizedString("OnboardingCText", comment: ""),
        color: Color("Button")
    )
]
