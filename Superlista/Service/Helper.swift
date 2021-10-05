//
//  Helper.swift
//  Superlista
//
//  Created by Gabriela Zorzo on 05/10/21.
//

import Foundation
import CloudKit
import SwiftUI

// MARK: - ImageToCKAsset
func ImageToCKAsset(uiImage: UIImage?) -> CKAsset? {
    if uiImage == nil { return nil }
    let data = uiImage!.jpegData(compressionQuality: 0.5); // UIImage -> NSData, see also UIImageJPEGRepresentation
    let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat")!
    do {
        try data?.write(to: url) //data!.writeToURL(url, options: [])
    } catch let e as NSError {
        print("Error! \(e)");
        return nil
    }
    return CKAsset(fileURL: url)
}

// MARK: - CKAssetToImage
func CKAssetToImage(ckImage: CKAsset?) -> Image? {
    guard let image: UIImage = CKAssetToUIImage(ckImage: ckImage) else {
        return nil
    }
    return Image(uiImage: image)
}

// MARK: - CKAssetToUIImage
func CKAssetToUIImage(ckImage: CKAsset?) -> UIImage? {
    if ckImage == nil { return nil }
    
    guard
        let photo = ckImage,
        let fileURL = photo.fileURL //verificar url se voltar a deitar a foto
    else {
        return nil
    }
    
    let imageData: Data
    do {
        imageData = try Data(contentsOf: fileURL)
    } catch {
        return nil
    }
    
    guard let image: UIImage = UIImage(data: imageData) else {
        return nil
    }
    return image //UIImage
}
