//
//  AlertTest.swift
//  Superlista
//
//  Created by Gabriela Zorzo on 17/05/21.
//

import SwiftUI

struct AlertTest: View {
    var body: some View {
        Text("oi")
//        func alertWithTF() {
//            //Step : 1
//            let alert = UIAlertController(title: "Great Title", message: "Please input something", preferredStyle: UIAlertController.Style.alert )
//            //Step : 2
//            let save = UIAlertAction(title: "Save", style: .default) { (alertAction) in
//                let textField = alert.textFields![0] as UITextField
//                let textField2 = alert.textFields![1] as UITextField
//                if textField.text != "" {
//                    //Read TextFields text data
//                    print(textField.text!)
//                    print("TF 1 : \(textField.text!)")
//                } else {
//                    print("TF 1 is Empty...")
//                }
//
//                if textField2.text != "" {
//                    print(textField2.text!)
//                    print("TF 2 : \(textField2.text!)")
//                } else {
//                    print("TF 2 is Empty...")
//                }
//            }
//
//            //Step : 3
//            //For first TF
//            alert.addTextField { (textField) in
//                textField.placeholder = "Enter your first name"
//                textField.textColor = .red
//            }
//            //For second TF
//            alert.addTextField { (textField) in
//                textField.placeholder = "Enter your last name"
//                textField.textColor = .blue
//            }
//
//            //Step : 4
//            alert.addAction(save)
//            //Cancel action
//            let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in }
//            alert.addAction(cancel)
//            //OR single line action
//            //alert.addAction(UIAlertAction(title: "Cancel", style: .default) { (alertAction) in })
//
//            self.present(alert, animated:true, completion: nil)
//
//        }
    }
}

struct AlertTest_Previews: PreviewProvider {
    static var previews: some View {
        AlertTest()
    }
}
