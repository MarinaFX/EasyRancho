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
        return Color(#colorLiteral(red: 0.5810584426, green: 0.1285524964, blue: 0.5745313764, alpha: 1))
    case "Bebidas" :
        return Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1))
    case "Bomboniere" :
        return Color(#colorLiteral(red: 1, green: 0.5409764051, blue: 0.8473142982, alpha: 1))
    case "Carnes" :
        return Color(#colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1))
    case "Compotas e doces" :
        return Color(#colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1))
    case "Congelados" :
        return Color(#colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1))
    case "Enlatados, conservas e óleos" :
        return Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
    case "Especiais" :
        return Color(#colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1))
    case "Fiambreria e laticínios" :
        return Color(#colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1))
    case "Grãos e farinhas" :
        return Color(#colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1))
    case "Higiene e beleza" :
        return Color(#colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1))
    case "Hortifruti" :
        return Color(#colorLiteral(red: 0.002171693299, green: 0.7648209851, blue: 0.003369579887, alpha: 1))
    case "Limpeza" :
        return Color(#colorLiteral(red: 0.3279305806, green: 0.5340757538, blue: 0.7648209851, alpha: 1))
    case "Massas e biscoitos" :
        return Color(#colorLiteral(red: 0.7648209851, green: 0.2162549645, blue: 0.0740083311, alpha: 1))
    case "Matinais" :
        return Color(#colorLiteral(red: 0.7648209851, green: 0.4641872926, blue: 0.07614424426, alpha: 1))
    case "Molhos" :
        return Color(#colorLiteral(red: 0.7648209851, green: 0.1147455203, blue: 0, alpha: 1))
    case "Padaria" :
        return Color(#colorLiteral(red: 0.6081647006, green: 0.3592944152, blue: 0.0009945463737, alpha: 1))
    case "PetShop" :
        return Color(#colorLiteral(red: 1, green: 0.5283442979, blue: 0.6007381254, alpha: 1))
    case "Sobremesas" :
        return Color(#colorLiteral(red: 1, green: 0, blue: 0.3338502113, alpha: 1))
    case "Temperos" :
        return Color(#colorLiteral(red: 0.02731248881, green: 0.3034298059, blue: 0.1160795366, alpha: 1))
    default:
        return Color.black
    }
}
