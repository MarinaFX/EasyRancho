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
        imageHint: "Ilustração de um carrinho de compras cheio acima de um grande smartphone em um fundo verde.",
        imageLabel: "Carrinho de Compras"
    ),
    OnboardingPage(
        image: NSLocalizedString("OnboardingB", comment: "Onboarding B Image"),
        title: NSLocalizedString("OnboardingBTitle", comment: "Onboarding B Title"),
        text: NSLocalizedString("OnboardingBText", comment: "Onboarding B Text"),
        color: Color("Higieneebeleza"),
        imageHint: "Ilustração de uma mulher segurando um smartphone acompanhada por outra pessoa que empurra um carrinho de compras em um fundo azul.",
        imageLabel: "Compras"
    ),
    OnboardingPage(
        image: NSLocalizedString("OnboardingC", comment: "Onboarding C Image"),
        title: NSLocalizedString("OnboardingCTitle", comment: "Onboarding C Title"),
        text: NSLocalizedString("OnboardingCText", comment: "Onboarding C Text"),
        color: Color("Onboarding"),
        imageHint: "Ilustração de um cesto de produtos marrom",
        imageLabel: "Cesto de produtos"
    )
]
