import Foundation
import CloudKit
import SwiftUI

//MARK: - Owner Model Class

/**
    Modelo de usuário do CloudKit para ser usado no owner de uma lista e no sharedWith das listas.
 */
class CKOwnerModel {
    
    //MARK: CKOwnerModel Variables
    
    var id: CKRecord.ID
    var name: String?
    var ckImage: CKAsset?
    var image: UIImage?
    
    init(record: CKRecord) {
        id = record.recordID
        name = record["UserName"] as? String
        ckImage = record["Image"] as? CKAsset
        image = CKAssetToUIImage(ckImage: ckImage)
    }
    
    init() {
        id = CKRecord.ID()
    }
    
    init(id: CKRecord.ID, name: String) {
        self.id = id
        self.name = name
    }
}
