import Foundation
import UIKit
import SwiftUI

class UserModel: Identifiable, Decodable, Encodable {
    
    var id: String
    var name: String?
    var customProducts: [ProductModel]?
    var myLists: [ListModel]?
    var sharedWithMe: [ListModel]?
    
    init(id: String, name: String? = getNickname(), customProducts: [ProductModel]? = [], myLists: [ListModel]? = [], sharedWithMe: [ListModel]? = []) {
        
        self.id = id
        self.name = name
        self.customProducts = customProducts
        self.myLists = myLists
        self.sharedWithMe = sharedWithMe
    }
    
    func updateLists(lists: [ListModel]) -> UserModel {
        let updatedMyLists = lists.filter({ $0.owner.id == id })
        let updatedSharedWithMe = lists.filter({ list in !updatedMyLists.contains(where: { list.id == $0.id })})

        return UserModel(id: id, name: name, customProducts: customProducts, myLists: updatedMyLists, sharedWithMe: updatedSharedWithMe)
    }
}
