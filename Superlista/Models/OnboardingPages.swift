import Foundation
import SwiftUI

struct Page {
    let image: String
    let title: String
    let text: String
    let color: Color
}

let onboardingPages = [
    Page(image: "OnboardingA", title: "Bem-vindo", text: "Crie listas de supermercado categorizadas de maneira fácil e simples!", color: Color("HeaderColor")),
    Page(image: "OnboardingB", title: "Listas Colaborativas", text: "Crie listas compartilhadas e adicione colaboradores para que possam editar em tempo real.", color: Color("Higieneebeleza")),
    Page(image: "OnboardingC", title: "Personalize itens", text: "Adicione novos produtos, quantidades e comentários a sua lista.", color: Color("Selected"))
]
