//
//  ItemsListViewModel.swift
//  Superlista
//
//  Created by Thaís Fernandes on 05/05/21.
//

import Foundation

class ProductListViewModel {
    
    public let products: [ProductModel]
    let productsOrdered: [ProductModel]
        
    init() {
        self.products = load("productList.json")
        self.productsOrdered = products.sorted(by: { $0.name < $1.name })
    }
    
}
