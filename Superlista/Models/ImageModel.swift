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
        return Image("Bazar")
    case "Bebidas" :
        return Image("Bebidas")
    case "Bomboniere" :
        return Image("Bomboniere")
    case "Carnes" :
        return Image("Carnes")
    case "Compotas e doces" :
        return Image("Compotasedoces")
    case "Congelados" :
        return Image("Congelados")
    case "Enlatados, conservas e óleos" :
        return Image("Enlatadosconservaseoleos")
    case "Especiais" :
        return Image("Especiais")
    case "Fiambreria e laticínios" :
        return Image("Fiambreriaelaticinios")
    case "Grãos e farinhas" :
        return Image("Graosefarinhas")
    case "Higiene e beleza" :
        return Image("Higieneebeleza")
    case "Hortifruti" :
        return Image("Hortifruti")
    case "Limpeza" :
        return Image("Limpeza")
    case "Massas e biscoitos" :
        return Image("Massasebiscoitos")
    case "Matinais" :
        return Image("Matinais")
    case "Molhos" :
        return Image("Molhos")
    case "Padaria" :
        return Image("Padaria")
    case "PetShop" :
        return Image("PetShop")
    case "Sobremesas" :
        return Image("Sobremesas")
    case "Temperos" :
        return Image("Temperos")
    case "Outros" :
        return Image("Outros")
    default:
        return Image("Ilustra") 
    }
}
