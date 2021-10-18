//
//  UserModel.swift
//  Superlista
//
//  Created by Marina De Pazzi on 15/10/21.
//

import Foundation
import UIKit
import SwiftUI

class UserModel {
    
    var id: String
    var name: String?
    var image: UIImage?
    var customProducts: [ProductModel]?
    var favoriteLists: [ListModel]?
    var myLists: [ListModel]?
    var sharedWithMe: [ListModel]?
    
    #warning("Substituir a string fazia pelo nome aleatorio")
    init(id: String, name: String? = "", image: UIImage? = nil, customProducts: [ProductModel]? = [], favoriteLists: [ListModel]? = [], myLists: [ListModel]? = [], sharedWithMe: [ListModel]? = []) {
        
        self.id = id
        self.name = name
        self.image = image
        self.customProducts = customProducts
        self.favoriteLists = favoriteLists
        self.myLists = myLists
        self.sharedWithMe = sharedWithMe
    }
    
}
