//
//  CreateNewCustomProductView.swift
//  Superlista
//
//  Created by Marina De Pazzi on 29/10/21.
//

import SwiftUI

struct CreateNewCustomProductView: View {
    @Environment(\.sizeCategory) var sizeCategory
    
    @EnvironmentObject var dataService: DataService
    
    @ScaledMetric var buttonHeight: CGFloat = UIScreen.main.bounds.width * 0.15
    
    @Binding var showCreateNewProductView: Bool
    @Binding var didCreateNewProduct: Bool
    
    @State var productName: String = ""
    @State private var lastSelectedItem: Int?
    @State var didLeaveNameTextFieldEmpty: Bool = false
    @State var didAddProductSuccessfully: Bool = false
    @State var didFinishCreatingProduct: Bool = false
    @State var duplicatedName: String = ""
    
    let categories: [String] = loadCategoryKeys()
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .center) {
                    //MARK: Title and Description section
                    Text("createProductScreenTitle")
                        .font(.title)
                        .bold()
                        .padding(.top, 16)
                    
                    Text("createProductDescription")
                        .font(.body)
                        .padding(EdgeInsets(top: 8, leading: 16, bottom: 24, trailing: 16))
                        .multilineTextAlignment(.center)
                    
                    FormView(productName: $productName, lastSelectedItem: $lastSelectedItem, didLeaveNameTextFieldEmpty: $didLeaveNameTextFieldEmpty, didAddProductSuccessfully: $didAddProductSuccessfully, didFinishCreatingProduct: $didFinishCreatingProduct, duplicatedName: $duplicatedName)
                    
                    Spacer()
                    
                    if !didAddProductSuccessfully && didFinishCreatingProduct {
                        Text("duplicateProductWarning \(duplicatedName)")
                            .font(.callout)
                            .foregroundColor(.red)
                            .padding(16)
                            .accessibility(hidden: false)
                    }
                    
                    //MARK: Bottom Button
                    Button (
                        action: saveProduct,
                        label: {
                            Text("trailingDone")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                                .accessibilityHint("ACDoneButtonHint")
                            
                        })
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: buttonHeight)
                        .background(Color("InsetGroupedBackground"))
                        .cornerRadius(14)
                        .padding(.bottom, 20)
                    
                }
                .frame(maxWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height * 0.85)
                
                //MARK: Sheet's top buttons
                .toolbar {
                    //MARK: Leading cancel
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            self.showCreateNewProductView = false
                        } label: {
                            Text("leadingCancel")
                                .font(.body)
                                .foregroundColor(.blue)
                                .accessibilityHint("ACCancelButtonHint")
                        }
                    }
                    
                    //MARK: Trailing done
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button (
                            action: saveProduct,
                            label: {
                                Text("trailingDone")
                                    .font(.body)
                                    .bold()
                                    .foregroundColor(.blue)
                                    .accessibilityHint("ACDoneButtonHint")
                            })
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
            }
        }.foregroundColor(.primary)
        
    }
    
    func saveProduct() {
        guard let lastSelectedItem = lastSelectedItem else {
            self.didLeaveNameTextFieldEmpty = true
            return
        }
        
        if !productName.isEmpty {
            didAddProductSuccessfully = dataService.updateCustomProducts(withName: productName, for: categories[lastSelectedItem])
            
            didFinishCreatingProduct = true
            
            if didAddProductSuccessfully {
                self.showCreateNewProductView = false
                self.didCreateNewProduct.toggle()
            }
            
            duplicatedName = productName
        } else {
            self.didLeaveNameTextFieldEmpty = true
        }
    }
}

struct CreateNewCustomProductView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewCustomProductView(showCreateNewProductView: .constant(false), didCreateNewProduct: .constant(false))
    }
}

struct FormView: View {
    @Environment(\.sizeCategory) var sizeCategory
    
    @ScaledMetric var textViewHeight: CGFloat = UIScreen.main.bounds.height * 0.1
    
    @Binding var productName: String
    @Binding var lastSelectedItem: Int?
    @Binding var didLeaveNameTextFieldEmpty: Bool
    @Binding var didAddProductSuccessfully: Bool
    @Binding var didFinishCreatingProduct: Bool
    @Binding var duplicatedName: String
    
    let categories: [String] = loadCategoryKeys()
    
    var body: some View {
        //MARK: Required field text when textfield is empty
        Text("textFieldRequired")
            .font(.callout)
            .foregroundColor(didLeaveNameTextFieldEmpty ? .red : .gray)
            .padding(.bottom, -24)
            .padding(.trailing,
                     sizeCategory > ContentSizeCategory.accessibilityExtraLarge ?
                     UIScreen.main.bounds.width * 0.25 :
                        (sizeCategory < ContentSizeCategory.extraExtraLarge ? UIScreen.main.bounds.width * 0.6 : UIScreen.main.bounds.width * 0.55)
            )
            .accessibility(hidden: true)
        
        //MARK: Product name TextField
        TextField(
            NSLocalizedString("productNameTextField", comment: ""),
            text: $productName,
            onEditingChanged: { (didStartEditing) in
                if !didStartEditing {
                    self.didLeaveNameTextFieldEmpty = !productName.isEmpty
                }
            }
        )
            .modifier(CustomTextFieldStyle(strokeColor: didLeaveNameTextFieldEmpty ? .red : .gray))
            .padding(.bottom, -16)
            .accessibilityHint("ACtextFieldRequiredHint")
        
        //MARK: Product category TextPickerField
        PickerTextField(lastSelectedIndex: self.$lastSelectedItem, data: categories, placeholder: NSLocalizedString("productCategoryTextField", comment: "")
        )
            .modifier(CustomTextFieldStyle())
            .frame(height: textViewHeight)
            .accessibilityLabel("ACpickerFieldLabel")
            .accessibilityValue("ACpickerFieldValue")
            .accessibilityHint("ACtextFieldRequiredHint")
    }
}
