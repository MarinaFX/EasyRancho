//
//  UserModel.swift
//  Superlista
//
//  Created by Gabriela Zorzo on 04/10/21.
//

import Foundation
import CloudKit
import SwiftUI

//MARK: - UserModel Class

/**
 
 */
class UserModel {
    
    //MARK: UserModel Variables
    private(set) var id: CKRecord.ID
    var name: String?
    var ckImage: CKAsset?
    var image: Image?
    var customItems: [String]?
    var favoriteLists: [CKRecord.Reference]?
    var myLists: [CKRecord.Reference]?
    var sharedWithMe: [CKRecord.Reference]?
    
    init(record: CKRecord) {
        id = record.recordID
        
        name = record["UserName"] as? String
        ckImage = record["Image"] as? CKAsset
        image = CKAssetToImage(ckImage: ckImage)
        customItems = record["CustomItems"] as? [String] ?? []
        favoriteLists = record["FavoriteLists"] as? [CKRecord.Reference] ?? []
        myLists = record["MyLists"] as? [CKRecord.Reference] ?? []
        sharedWithMe = record["SharedWithMe"] as? [CKRecord.Reference] ?? []
    }
}
