//
//  CKUserModel.swift
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
class CKUserModel {
    
    //MARK: CKUserModel Variables
    
    var id: CKRecord.ID
    var name: String?
    var ckImage: CKAsset?
    var image: UIImage?
    
    var customItemsString: [String]?
    var customItems: [CKItemModel]?
    
    var favoriteListsRef: [CKRecord.Reference]?
    var favoriteLists: [CKListModel]?
    
    var myListsRef: [CKRecord.Reference]?
    var myLists: [CKListModel]?
    
    var sharedWithMeRef: [CKRecord.Reference]?
    var sharedWithMe: [CKListModel]?
    
    let itemConverter: ItemModelConverter = ItemModelConverter()
    let ListConverter: ListModelConverter = ListModelConverter()

    
    init(record: CKRecord) {
        id = record.recordID
        
        name = record["UserName"] as? String
        ckImage = record["Image"] as? CKAsset
        image = CKAssetToUIImage(ckImage: ckImage)
        
        customItemsString = record["CustomItems"] as? [String] ?? []
        customItems = itemConverter.parseStringToCKItemObject(withString: customItemsString ?? [])
        
        favoriteListsRef = record["FavoriteLists"] as? [CKRecord.Reference] ?? []
        favoriteLists = ListConverter.convertListReferenceToCloudList(withList: favoriteListsRef ?? [])
        
        myListsRef = record["MyLists"] as? [CKRecord.Reference] ?? []
        myLists = ListConverter.convertListReferenceToCloudList(withList: myListsRef ?? [])
        
        sharedWithMeRef = record["SharedWithMe"] as? [CKRecord.Reference] ?? []
        sharedWithMe = ListConverter.convertListReferenceToCloudList(withList: sharedWithMeRef ?? [])
    }
    
    init(id: CKRecord.ID, name: String? = "", ckImage: CKAsset? = nil, customItemsString: [String], favoriteLists: [CKListModel]? = [], myLists: [CKListModel]? = [], sharedWithMe: [CKListModel]? = []) {
        
        self.id = id
        self.name = name
        self.ckImage = ckImage
        self.image = CKAssetToUIImage(ckImage: ckImage)
        
        self.customItemsString = customItemsString
        self.customItems = itemConverter.parseStringToCKItemObject(withString: customItemsString)
        
        self.favoriteLists = favoriteLists
        self.favoriteListsRef = []
        
        for list in favoriteLists! {
            favoriteListsRef?.append((CKRecord.Reference(recordID: list.id, action: CKRecord.ReferenceAction.none)))
        }
        
        self.myLists = myLists
        self.myListsRef = []
        
        for list in myLists! {
            myListsRef?.append((CKRecord.Reference(recordID: list.id, action: CKRecord.ReferenceAction.none)))
        }
        
        self.sharedWithMe = sharedWithMe
        self.sharedWithMeRef = []
        
        for list in sharedWithMe! {
            sharedWithMeRef?.append((CKRecord.Reference(recordID: list.id, action: CKRecord.ReferenceAction.none)))
        }
    }
}