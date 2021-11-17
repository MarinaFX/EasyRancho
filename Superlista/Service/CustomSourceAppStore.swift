//
//  CustomSourceAppStore.swift
//  Superlista
//
//  Created by Gabriela Zorzo on 17/11/21.
//

import UIKit
import LinkPresentation

class CustomSourceAppStore: NSObject, UIActivityItemSource {
    let url = URL(string: "https://apps.apple.com/br/app/easyrancho-lista-de-compras/id1568546773")
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return url!
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        
        let text = NSLocalizedString("InviteMessage", comment: "InviteMessage")
        
        return "\(text): \(url!)"
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        let image = UIImage(named: "AppIcon")
        
        metadata.title = NSLocalizedString("InviteMessage", comment: "InviteMessage")
        
        if let img = image {
            metadata.imageProvider = NSItemProvider(object: img)
        }
        
        return metadata
    }
}

