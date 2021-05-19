//
//  CategoryModel.swift
//  Superlista
//
//  Created by Thaís Fernandes on 18/05/21.
//

import Foundation

struct CategoryModel: Decodable, Hashable, Encodable {
    let title: String
    var order: Int = 0
}
