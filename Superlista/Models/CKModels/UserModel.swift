//
//  UserModel.swift
//  Superlista
//
//  Created by Gabriela Zorzo on 04/10/21.
//

import Foundation
import CloudKit
import SwiftUI

class UserModel {
    private(set) var id: CKRecord.ID
    var name: String?
    var image: CKAsset?
    var customItems: [String]?
    var favoriteLists: [CKRecord.Reference]?
    var myLists: [CKRecord.Reference]?
    var sharedWithMe: [CKRecord.Reference]?
    
    init(record: CKRecord) {
        id = record.recordID
        
        name = record["Name"] as? String
        image = record["Image"] as? CKAsset
        customItems = record["CustomItems"] as? [String] ?? []
        favoriteLists = record["FavoriteLists"] as? [CKRecord.Reference] ?? []
        myLists = record["MyLists"] as? [CKRecord.Reference] ?? []
        sharedWithMe = record["SharedWithMe"] as? [CKRecord.Reference] ?? []
    }
}
