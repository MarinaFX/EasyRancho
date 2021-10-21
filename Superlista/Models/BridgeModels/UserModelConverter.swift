import Foundation
import SwiftUI
import CloudKit

//MARK: - UserModelConverter Class

/**
 UserModelConverter is a Bridge class converting our Cloud record/class of User arquitecture to our local/UserDefaults class arquitecture.
 
 According to its formal definition, a Bridge is something that meakes its easier to change from one situation to another. In this case, instead of refactoring the whole backend everytime we make a new implementation of a service, a Bridge class connects both arquitectures by parsing each to each. This way is possible to manipulate both strcutures without backend refactoring.
 */
class UserModelConverter {
    private let itemConverter: ItemModelConverter = ItemModelConverter()
    private let listConverter: ListModelConverter = ListModelConverter()
    private let productConverter: ProductModelConverter = ProductModelConverter()
    
    //MARK: UserModelConverter Functions: ☁️ to Local
    
    /**
    This method converts our current cloud CKItemModel structure to our local ItemModel structure
     
     - Parameters:
        - items: the cloud list of items to be converted
     - Returns: the ItemModel version of the given CKItemModel list
     */
    func convertCloudUserToLocal(withUser user: CKUserModel) -> UserModel {
        let id: String
        let name: String
        let customProducts: [ProductModel]
        var myLists: [ListModel] = []
        var sharedWithMe: [ListModel] = []
                
        id = user.id.recordName
        name = user.name ?? "nome aleatorio"
        customProducts = productConverter.convertStringToProducts(withString: user.customProductsString ?? [])
        
        for list in user.myLists! {
            myLists.append(listConverter.convertCloudListToLocal(withList: list))
        }
        
        for list in user.sharedWithMe! {
            sharedWithMe.append(listConverter.convertCloudListToLocal(withList: list))
        }
        
        let localUser: UserModel = UserModel(id: id, name: name, customProducts: customProducts, myLists: myLists, sharedWithMe: sharedWithMe)

        
        return localUser
    }
    
    
    /**
    This method converts our cloud CKUserModel structure to a CKRecord.reference
     
     - Parameters:
        - user: the user to be converted - CKUserModel
     - Returns: the CKRecord.Reference version of the given CKUserModel
     */
    
    func convertCloudUserToReference(withUser user: CKUserModel) -> CKRecord.Reference {
            return CKRecord.Reference(recordID: user.id, action: .none)
    }
    
    //MARK: UserModelConverter Functions: Local to ☁️
    
    /**
    This method converts our current local ItemModel structure to our cloud CKItemModel structure
     
     - Parameters:
        - items: the local list of items to be converted
     - Returns: the CKItemModel version of the given ItemModel list
     */
    func convertLocalUserToCloud(withUser user: UserModel) -> CKUserModel {
        let id: CKRecord.ID
        let name: String
        let customProductsString: [String]
        
        var myLists: [CKListModel] = []
        var sharedWithMe: [CKListModel] = []
        
        id = CKRecord.ID(recordName: user.id)
        name = user.name ?? "nome aleatorio"
        customProductsString = productConverter.convertLocalProductsToString(withProducts: user.customProducts ?? [])
        
        for list in user.myLists! {
            myLists.append(listConverter.convertLocalListToCloud(withList: list))
        }
        
        for list in user.sharedWithMe! {
            sharedWithMe.append(listConverter.convertLocalListToCloud(withList: list))
        }
        
        let cloudUser: CKUserModel = CKUserModel(id: id, name: name, customProductsString: customProductsString, myLists: myLists, sharedWithMe: sharedWithMe)
        
        return cloudUser
    }
}
