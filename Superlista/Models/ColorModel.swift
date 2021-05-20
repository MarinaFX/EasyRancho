//
//  ColorModel.swift
//  Superlista
//
//  Created by Gabriela Zorzo on 12/05/21.
//

import Foundation
import SwiftUI

public func getColor(category: String) -> Color {
    switch category{
    case "Bazar" :
        return Color("Bazar")
    case "Bebidas" :
        return Color("Bebidas")
    case "Bomboniere" :
        return Color("Bomboniere")
    case "Carnes" :
        return Color("Carnes")
    case "Compotas e doces" :
        return Color("Compotas e doces")
    case "Congelados" :
        return Color("Congelados")
    case "Enlatados, conservas e óleos" :
        return Color("Enlatados, conservas e óleos")
    case "Especiais" :
        return Color("Especiais")
    case "Fiambreria e laticínios" :
        return Color("Fiambreria e laticínios")
    case "Grãos e farinhas" :
        return Color("Grãos e farinhas")
    case "Higiene e beleza" :
        return Color("Higiene e beleza")
    case "Hortifruti" :
        return Color("Hortifruti")
    case "Limpeza" :
        return Color("Limpeza")
    case "Massas e biscoitos" :
        return Color("Massas e biscoitos")
    case "Matinais" :
        return Color("Matinais")
    case "Molhos" :
        return Color("Molhos")
    case "Padaria" :
        return Color("Padaria")
    case "PetShop" :
        return Color("PetShop")
    case "Sobremesas" :
        return Color("Sobremesas")
    case "Temperos" :
        return Color("Temperos")
    case "Outros" :
        return Color("Outros")
    default:
        return Color.black
    }
}
