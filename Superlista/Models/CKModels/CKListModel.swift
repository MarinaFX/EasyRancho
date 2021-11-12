import Foundation
import CloudKit

class CKListModel {
    var id: CKRecord.ID
    var name: String?
    var itemsString: [String] = []
    var itemsModel: [CKItemModel] = []
    
    var ownerRef: CKRecord.Reference
    var owner: CKOwnerModel?
    
    var sharedWithRef: [CKRecord.Reference] = []
    var sharedWith: [CKOwnerModel] = []
    
    let itemConverter: ItemModelConverter = ItemModelConverter()
        
    init(completion: ((CKListModel) -> Void)? = nil) {
        
        let group = DispatchGroup()
        
        id = CKRecord.ID()
        name = NSLocalizedString("NovaLista", comment: "Nova Lista")
        
        group.enter()
        
        let UDuser = UDService().getUDUser()
        
        #warning("gambiarra para nao crashar por enquanto")
        ownerRef = CKRecord.Reference(recordID: CKRecord.ID(recordName: UDuser?.id ?? "gambiarra"), action: .none)
        OwnerModelConverter().convertReferenceToCK(withReference: ownerRef) { result in
            switch result {
            case .success(let user):
                self.owner = user
            case .failure:
                return
            }
            group.leave()
        }
        
        group.wait()
        
        completion?(self)
    }
    
    init(record: CKRecord, completion: ((CKListModel) -> Void)? = nil) {
        let group = DispatchGroup()
        
        id = record.recordID
        itemsString = record["Items"] as? [String] ?? []
        name = record["ListName"] as? String 
        itemsModel = itemConverter.parseStringToCKItemObject(withString: itemsString)
        
        group.enter()
        
        ownerRef = record["Owner"] as! CKRecord.Reference
        OwnerModelConverter().convertReferenceToCK(withReference: ownerRef) { result in
            switch result {
            case .success(let owner):
                self.owner = owner
            case .failure:
                return
            }
            group.leave()
        }
        
        group.enter()
        
        sharedWithRef = record["SharedWith"] as? [CKRecord.Reference] ?? []
        OwnerModelConverter().convertReferenceToCK(withReference: sharedWithRef) { result in
            switch result {
            case .success(let cloudOwners):
                self.sharedWith = cloudOwners
            case .failure:
                return
            }
            
            group.leave()
        }
        
        group.wait()
        
        completion?(self)
    }
    
    init(name: String, ownerRef: CKRecord.Reference, itemsString: [String], completion: ((CKListModel) -> Void)? = nil) {
        let group = DispatchGroup()
        
        id = CKRecord.ID()
        self.itemsString = itemsString
        self.name = name
        itemsModel = itemConverter.parseStringToCKItemObject(withString: itemsString)
        
        group.enter()
        
        self.ownerRef = ownerRef
        OwnerModelConverter().convertReferenceToCK(withReference: ownerRef) { result in
            switch result {
            case .success(let owner):
                self.owner = owner
            case .failure:
                return
            }
            group.leave()
        }
        
        group.wait()
        
        completion?(self)
    }
}
