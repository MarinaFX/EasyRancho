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
    
    #warning("Localizar o nome da lista")
    
    init() {
        self.id = CKRecord.ID()
        self.name = "Nova Lista"
    }
    
    init(record: CKRecord) {
        id = record.recordID
        itemsString = record["Items"] as? [String] ?? []
        name = record["ListName"] as? String 
        parseToItemsModel()
    }
    
    func parseToItemsModel() {
        for item in itemsString {
            let contents = item.components(separatedBy: ";")
            let name = contents[0] as String
            let category = contents[1] as String
            let quantity = (Int(contents[2]) ?? 1) as Int
            let comment = contents[3] == "nil" ? nil : contents[3]
            let isCompleted = contents[4] == "true" ? true : false
            let item = CKItemModel(name: name, category: category, quantity: quantity, comment: comment, isCompleted: isCompleted)
            itemsModel.append(item)
        }
    }
    
    func parseToCSV() {
        itemsModel.forEach { item in
            itemsString.append(item.name + String(item.quantity) + (item.comment ?? "") + String(item.isCompleted))
        }
    }
}
