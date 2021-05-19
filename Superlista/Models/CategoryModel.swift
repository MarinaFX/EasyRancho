//
//  CategoryModel.swift
//  Superlista
//
//  Created by Thaís Fernandes on 18/05/21.
//

import Foundation

struct CategoryModel: Decodable, Hashable, Encodable {
    let id: String
    let title: String
    var order: Int?
    
    init(id: String = UUID().uuidString, title: String, order: Int? = nil) {
        self.id = id
        self.title = title
        self.order = order
    }
    
    func setOrder(newOrder: Int) -> CategoryModel {
        return CategoryModel(id: id, title: title, order: newOrder)
    }
}
