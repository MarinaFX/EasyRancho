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
        return Color("Compotasedoces")
    case "Congelados" :
        return Color("Congelados")
    case "Enlatados, conservas e óleos" :
        return Color("Enlatadosconservaseoleos")
    case "Especiais" :
        return Color("Especiais")
    case "Fiambreria e laticínios" :
        return Color("Fiambreriaelaticinios")
    case "Grãos e farinhas" :
        return Color("Grãos e farinhas")
    case "Higiene e beleza" :
        return Color("Higieneebeleza")
    case "Hortifruti" :
        return Color("Hortifruti")
    case "Limpeza" :
        return Color("Limpeza")
    case "Massas e biscoitos" :
        return Color("Massasebiscoitos")
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
