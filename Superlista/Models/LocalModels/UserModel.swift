//
//  UserModel.swift
//  Superlista
//
//  Created by Marina De Pazzi on 15/10/21.
//

import Foundation
import UIKit
import SwiftUI

class UserModel: Identifiable, Decodable, Encodable {
    
    var id: String
    var name: String?
    var customProducts: [ProductModel]?
    var favoriteLists: [ListModel]?
    var myLists: [ListModel]?
    var sharedWithMe: [ListModel]?
    
    #warning("Substituir a string fazia pelo nome aleatorio")
    init(id: String, name: String? = "", customProducts: [ProductModel]? = [], favoriteLists: [ListModel]? = [], myLists: [ListModel]? = [], sharedWithMe: [ListModel]? = []) {
        
        self.id = id
        self.name = name
        self.customProducts = customProducts
        self.favoriteLists = favoriteLists
        self.myLists = myLists
        self.sharedWithMe = sharedWithMe
    }
    
}
