import Foundation
import CloudKit

class CKListModel {
    var id: CKRecord.ID
    var name: String?
    var itemsString: [String] = []
    var itemsModel: [CKItemModel] = []
    
    var ownerRef: CKRecord.Reference
    var owner: CKUserModel?
    
    var sharedWithRef: [CKRecord.Reference] = []
    var sharedWith: [CKUserModel] = []
    
    let itemConverter: ItemModelConverter = ItemModelConverter()
    
    #warning("Localizar o nome da lista")
    
    init() {
        self.id = CKRecord.ID()
        self.name = "Nova Lista"
        self.ownerRef = CKRecord.Reference(recordID: CKService.currentModel.user!.id, action: .none)
        owner = CKUserModel(record: CKRecord(recordType: "User", recordID: ownerRef.recordID))
    }
    
    init(record: CKRecord) {
        id = record.recordID
        itemsString = record["Items"] as? [String] ?? []
        name = record["ListName"] as? String 
        itemsModel = itemConverter.parseStringToCKItemObject(withString: itemsString)
        
        ownerRef = record["Owner"] as! CKRecord.Reference
   //     owner = CKUserModel(record: CKRecord(recordType: "User", recordID: ownerRef.recordID))
        
        sharedWithRef = record["SharedWith"] as? [CKRecord.Reference] ?? []
//        for shared in sharedWithRef {
//            let sharedWithUser = CKUserModel(record: CKRecord(recordType: "User", recordID: shared.recordID))
//            sharedWith.append(sharedWithUser)
//        }
    }
    
    init(name: String, ownerRef: CKRecord.Reference, itemsString: [String], sharedWithRef: [CKRecord.Reference]) {
        id = CKRecord.ID()
        self.itemsString = itemsString
        self.name = name
        itemsModel = itemConverter.parseStringToCKItemObject(withString: itemsString)
        
        self.ownerRef = ownerRef
 //       owner = CKUserModel(record: CKRecord(recordType: "User", recordID: ownerRef.recordID))
       
        
        self.sharedWithRef = sharedWithRef
//        for shared in sharedWithRef {
//            let sharedWithUser = CKUserModel(record: CKRecord(recordType: "User", recordID: shared.recordID)) 
//            sharedWith.append(sharedWithUser)
//        }
    }
}
