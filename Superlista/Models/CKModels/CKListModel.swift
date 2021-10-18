//
//  CKListModel.swift
//  Superlista
//
//  Created by Gabriela Zorzo on 04/10/21.
//

import Foundation
import CloudKit

class CKListModel {
    var id: CKRecord.ID
    var name: String?
    var itemsString: [String] = []
    var itemsModel: [CKItemModel] = []
    var owner: CKRecord.Reference
    var sharedWith: [CKRecord.Reference] = []
    
    let itemConverter: ItemModelConverter = ItemModelConverter()
    
    #warning("Localizar o nome da lista")
    
    init() {
        self.id = CKRecord.ID()
        self.name = "Nova Lista"
        self.owner = CKRecord.Reference(recordID: CKService.currentModel.user!.id, action: .none)
    }
    
    init(record: CKRecord) {
        id = record.recordID
        itemsString = record["Items"] as? [String] ?? []
        name = record["ListName"] as? String 
        itemsModel = itemConverter.parseStringToCKItemObject(withString: itemsString)
        owner = record["Owner"] as! CKRecord.Reference
        sharedWith = record["SharedWith"] as! [CKRecord.Reference]
    }
    
    init(name: String, owner: CKRecord.Reference, itemsString: [String]) {
        id = CKRecord.ID()
        self.itemsString = itemsString
        self.name = name
        itemsModel = itemConverter.parseStringToCKItemObject(withString: itemsString)
        self.owner = owner
    }
}
