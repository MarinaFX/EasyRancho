import SwiftUI

struct OnboardingPage {
    let image: String
    let title: String
    let text: String
    let color: Color
}

let onboardingPages = [
    OnboardingPage(
        image: NSLocalizedString("OnboardingA", comment: "Onboarding A Image"),
        title: NSLocalizedString("OnboardingATitle", comment: "Onboarding A Title"),
        text: NSLocalizedString("OnboardingAText", comment: "Onboarding A Text"),
        color: Color("Background")
    ),
    OnboardingPage(
        image: NSLocalizedString("OnboardingB", comment: "Onboarding B Image"),
        title: NSLocalizedString("OnboardingBTitle", comment: "Onboarding B Title"),
        text: NSLocalizedString("OnboardingBText", comment: "Onboarding B Text"),
        color: Color("Higieneebeleza")
    ),
    OnboardingPage(
        image: NSLocalizedString("OnboardingC", comment: "Onboarding C Image"),
        title: NSLocalizedString("OnboardingCTitle", comment: "Onboarding C Title"),
        text: NSLocalizedString("OnboardingCText", comment: "Onboarding C Text"),
        color: Color("Button")
    )
]
