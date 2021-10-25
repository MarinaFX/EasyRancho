import SwiftUI

struct OnboardingPage {
    let image: String
    let title: String
    let text: String
    let color: Color
}

let onboardingPages = [
    OnboardingPage(
        image: "OnboardingA",
        title: "Bem-vindo",
        text: "Crie listas de supermercado categorizadas de maneira fácil e simples!",
        color: Color("HeaderColor")
    ),
    OnboardingPage(
        image: "OnboardingB",
        title: "Listas Colaborativas",
        text: "Crie listas compartilhadas e adicione colaboradores para que possam editar em tempo real.",
        color: Color("Higieneebeleza")
    ),
    OnboardingPage(
        image: "OnboardingC",
        title: "Personalize itens",
        text: "Adicione novos produtos, quantidades e comentários a sua lista.",
        color: Color("Selected")
    )
]
