import SwiftUI

struct OnboardingPage {
    let image: String
    let title: String
    let text: String
    let color: Color
    let imageHint: String
    let imageLabel: String
}

let onboardingPages = [
    OnboardingPage(
        image: NSLocalizedString("OnboardingA", comment: "Onboarding A Image"),
        title: NSLocalizedString("OnboardingATitle", comment: "Onboarding A Title"),
        text: NSLocalizedString("OnboardingAText", comment: "Onboarding A Text"),
        color: Color("Background"),
        imageHint: NSLocalizedString("OnboardingAImageHint", comment: "Onboarding A Image Hint"),
        imageLabel: NSLocalizedString("OnboardingAImageLabel", comment: "Onboarding A Image Label")
    ),
    OnboardingPage(
        image: NSLocalizedString("OnboardingB", comment: "Onboarding B Image"),
        title: NSLocalizedString("OnboardingBTitle", comment: "Onboarding B Title"),
        text: NSLocalizedString("OnboardingBText", comment: "Onboarding B Text"),
        color: Color("Higieneebeleza"),
        imageHint: NSLocalizedString("OnboardingBImageHint", comment: "Onboarding B Image Hint"),
        imageLabel: NSLocalizedString("OnboardingBImageLabel", comment: "Onboarding B Image Label")
    ),
    OnboardingPage(
        image: NSLocalizedString("OnboardingC", comment: "Onboarding C Image"),
        title: NSLocalizedString("OnboardingCTitle", comment: "Onboarding C Title"),
        text: NSLocalizedString("OnboardingCText", comment: "Onboarding C Text"),
        color: Color("Onboarding"),
        imageHint: NSLocalizedString("OnboardingCImageHint", comment: "Onboarding C Image Hint"),
        imageLabel: NSLocalizedString("OnboardingCImageLabel", comment: "Onboarding C Image Label")
    )
]
