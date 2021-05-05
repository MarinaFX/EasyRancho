//
//  ItemsListViewModel.swift
//  Superlista
//
//  Created by Thaís Fernandes on 05/05/21.
//

import Foundation

class ProductListViewModel {
    
    public let products: [ProductModel]
        
    init() {
        self.products = load("productList.json")
    }
    
}
