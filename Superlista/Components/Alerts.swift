//
//  Alerts.swift
//  Superlista
//
//  Created by Thaís Fernandes on 10/11/21.
//

import UIKit

func textFieldAlert(title: String, message: String, placeholder: String, actionHandler: @escaping (String?) -> Void) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: NSLocalizedString("CreateListAlertCancelButton", comment: ""), style: .cancel, handler: nil))
    
    alert.addTextField { textField in
        textField.placeholder = placeholder
    }
    
    alert.addAction(UIAlertAction(title: NSLocalizedString("CreateListAlertMainButton", comment: ""), style: .default, handler: { action in
        actionHandler(alert.textFields?.first?.text)
    }))
    
    let viewController = UIApplication.shared.windows.first!.rootViewController!
    
    viewController.present(alert, animated: true)
}
