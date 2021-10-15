//
//  ListModelConverter.swift
//  Superlista
//
//  Created by Marina De Pazzi on 06/10/21.
//

/**
 - name -> ProductModel
 - category -> ProductModel
 
 - Comment -> ItemModel
 - IsCompleted -> ItemModel
 
 - Quantity (new) -> CKItemModel
 */

import Foundation
import CloudKit

//MARK: - ListModelConverter Class

/**
 ListModelConverter is a Bridge class converting our Cloud record/class of List arquitecture to our local/UserDefaults class arquitecture.
 
 According to its formal definition, a Bridge is something that meakes its easier to change from one situation to another. In this case, instead of refactoring the whole backend everytime we make a new implementation of a service, a Bridge class connects both arquitectures by parsing each to each. This way is possible to manipulate both strcutures without backend refactoring.
 */
class ListModelConverter {
    private let itemModelConverter = ItemModelConverter()

    //MARK: ListModelConverter Functions: Reference to ☁️
    
    func convertListReferenceToCloudList(withList list: [CKRecord.Reference]) -> [CKListModel] {
        var cloudList: [CKListModel] = []
        
        for list in list {
            CKService.currentModel.getList(listID: list.recordID) { result in
                switch result {
                case .success(let resultList):
                    cloudList.append(resultList)
                case .failure:
                    return
                }
            }
        }
        
        return cloudList
    }
    
    /**
     /**
     This method converts our current Cloud CKListModel structure to our local ListModel structure
      
      - Parameters:
         - list: the cloud list to be converted - CKListModel
      - Returns: the ListModel version of the given CKListModel list
      */
     */
    func convertCloudListToLocal(withList list: CKListModel) -> ListModel {
        let localList: ListModel
        
        let localItems = itemModelConverter.convertCloudItemsToLocal(withItems: list.itemsModel)
        
        localList = ListModel(id: list.id.recordName, title: list.name ?? "", items: localItems, favorite: false)
        
        
        return localList
    }
    
    //MARK: ListModelConverter Functions: Local to ☁️
    
    /**
    This method converts our current local ListModel structure to our cloud CKListModel structure
     
     - Parameters:
        - list: the local list to be converted - ListModel
     - Returns: the CKListModel version of the given ListModel list
     */
    func convertLocalListToCloud(withList list: ListModel) -> CKListModel {
        let cloudList: CKListModel = CKListModel()
        
        cloudList.id = CKRecord.ID(recordName: list.id)
        cloudList.name = list.title
        cloudList.itemsModel = itemModelConverter.convertLocalItemsToCloudItems(withItemsList: list.items)
        
        return CKListModel()
    }
}
