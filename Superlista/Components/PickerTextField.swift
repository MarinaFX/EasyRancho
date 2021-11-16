//
//  PickerTextField.swift
//  Superlista
//
//  Created by Marina De Pazzi on 30/10/21.
//

import Foundation
import SwiftUI

struct PickerTextField: UIViewRepresentable {
    
    @Binding var lastSelectedIndex: Int?
    
    private let textField = UITextField()
    private let pickerView = UIPickerView()
    private let accessoryView = AccessoryView()
    
    var data: [String]
    var placeholder: String
    
    func makeUIView(context: Context) -> UITextField {
        self.pickerView.delegate = context.coordinator
        self.pickerView.dataSource = context.coordinator
        
        //Dynamic Types
        let fontMetrics = UIFontMetrics.init(forTextStyle: .body)
        let font = UIFont.systemFont(ofSize: 17, weight: .regular)
        let placeholderScaledFont = fontMetrics.scaledFont(for: font)
        self.textField.font = placeholderScaledFont
        self.textField.adjustsFontForContentSizeCategory = true
        self.textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        
        self.textField.placeholder = self.placeholder
        self.textField.inputView = self.pickerView
        
        //Accessory view configuration
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: NSLocalizedString("trailingDone", comment: ""), style: .plain, target: self.accessoryView, action: #selector(self.accessoryView.doneButtonAction))
        
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        self.textField.inputAccessoryView = toolbar
        
        self.accessoryView.doneButtonTapped = {
            if self.lastSelectedIndex == nil {
                self.lastSelectedIndex = 0
            }
            self.textField.resignFirstResponder()
        }
        
        
        return self.textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        if let lastSelectedIndex = lastSelectedIndex {
            uiView.text = self.data[lastSelectedIndex]
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(data: self.data) { (index) in
            self.lastSelectedIndex = index
        }
    }
    
    class AccessoryView {
        
        public var doneButtonTapped: (() -> Void)?

        @objc func doneButtonAction() {
            self.doneButtonTapped?()
        }
    }
    
    class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        
        private var data: [String]
        private var didSelectItem: ((Int) -> Void)?
        
        init(data: [String], didSelectItem: ((Int) -> Void)? = nil) {
            self.data = data
            self.didSelectItem = didSelectItem
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return self.data.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return self.data[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.didSelectItem?(row)
        }
    }
    
}
