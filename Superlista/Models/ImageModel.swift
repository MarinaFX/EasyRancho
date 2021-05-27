//
//  ImageModel.swift
//  Superlista
//
//  Created by Gabriela Zorzo on 27/05/21.
//

import Foundation
import SwiftUI

public func getImage(category: String) -> Image {
    switch category{
    case "Bazar" :
        return Image("Ilustra")
    case "Bebidas" :
        return Image("Ilustra")
    case "Bomboniere" :
        return Image("Ilustra")
    case "Carnes" :
        return Image("Ilustra")
    case "Compotas e doces" :
        return Image("Ilustra")
    case "Congelados" :
        return Image("Ilustra")
    case "Enlatados, conservas e óleos" :
        return Image("Ilustra")
    case "Especiais" :
        return Image("Ilustra")
    case "Fiambreria e laticínios" :
        return Image("Ilustra")
    case "Grãos e farinhas" :
        return Image("Ilustra")
    case "Higiene e beleza" :
        return Image("Ilustra")
    case "Hortifruti" :
        return Image("Ilustra")
    case "Limpeza" :
        return Image("Ilustra")
    case "Massas e biscoitos" :
        return Image("Ilustra")
    case "Matinais" :
        return Image("Ilustra")
    case "Molhos" :
        return Image("Ilustra")
    case "Padaria" :
        return Image("Ilustra")
    case "PetShop" :
        return Image("Ilustra")
    case "Sobremesas" :
        return Image("Ilustra")
    case "Temperos" :
        return Image("Ilustra")
    case "Outros" :
        return Image("Ilustra")
    default:
        return Image("Ilustra") 
    }
}
