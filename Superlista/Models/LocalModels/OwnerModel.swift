import Foundation
import CloudKit
import SwiftUI

//MARK: - Owner Model Class

/**
    Modelo de usuário local para ser usado no owner de uma lista e no sharedWith das listas.
 */
class OwnerModel: Encodable, Decodable {
    
    //MARK: OwnerModel Variables
    
    var id: String
    var name: String?
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
