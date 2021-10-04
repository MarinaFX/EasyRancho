//
//  Item.swift
//  Superlista
//
//  Created by Marina De Pazzi on 04/05/21.
//

import Foundation

struct ProductModel : Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var category: String
    
    func getCategory() -> CategoryModel {
        return CategoryModel(title: category)
    }
}
