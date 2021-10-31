//
//  CreateNewCustomProductView.swift
//  Superlista
//
//  Created by Marina De Pazzi on 29/10/21.
//

import SwiftUI

struct CreateNewCustomProductView: View {
    @Binding var showCreateNewProductView: Bool
    
    @State var productName: String = ""
    //@State var selectedCategory: String = ""
    @State private var lastSelectedItem: Int?
    @State var didFillNameTextField: Bool = false
    @State var didFillCategoryTextField: Bool = false
    
    let categories: [String] = loadCategoryKeys()

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack(alignment: .center) {
                    Text("createProductScreenTitle")
                        .font(.system(size: 34))
                        .bold()
                        .padding(.top, 16)
                    
                    //MARK: CreateNewCustomProductView Form section
                    Text("createProductDescription")
                        .padding(EdgeInsets(top: -8, leading: 16, bottom: 24, trailing: 16))
                        .multilineTextAlignment(.center)
                    
                    Text("textFieldRequired")
                        .opacity(didFillNameTextField == true ? 0.0 : 1.0)
                        .font(.system(size: 13))
                        .foregroundColor(.red)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: -32, trailing: 256))
                    
                    TextField(
                        NSLocalizedString("productNameTextField", comment: ""),
                        text: $productName,
                        onEditingChanged: { (isBegin) in
                            if !isBegin {
                                if productName != "" {
                                    self.didFillNameTextField = true
                                }
                                else {
                                    self.didFillNameTextField = false
                                }
                            }
                        }
                    )
                        .modifier(CustomTextFieldStyle(strokeColor: didFillNameTextField == true ? Color.gray : Color.red))
                        .padding(.bottom, -12)
                    
                    PickerTextField(lastSelectedIndex: self.$lastSelectedItem, data: categories, placeholder: NSLocalizedString("productCategoryTextField", comment: ""))
                        .modifier(CustomTextFieldStyle())
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.1)
                    
                    Spacer()
                    
                    //MARK: CreateNewCustomProductView - Bottom Button
                    Button {
                        guard let lastSelectedItem = lastSelectedItem else {
                            return
                        }
                        
                        let cloudCustomProduct: String = productName + ";" + categories[lastSelectedItem]
                        let localCustomProduct: ProductModel = ProductModel(id: 999, name: productName, category: categories[lastSelectedItem])
                        
                        //TODO: Save locally on user's product json or a custom product json
                        
                        if didFillNameTextField {
                            //CloudIntegration().updateUserCustomProducts(withProduct: localCustomProduct)
                            
                            self.showCreateNewProductView = false
                        }

                    } label: {
                        Text("trailingDone")
                            .fontWeight(.semibold)
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                    }
                    .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.07)
                    .background(Color("InsetGroupedBackground"))
                    .cornerRadius(14)
                    .padding(.bottom, 16)
                    
                }
                
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            self.showCreateNewProductView = false
                        } label: {
                            Text("leadingCancel")
                                .font(.system(size: 17))
                                .foregroundColor(.blue)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            self.showCreateNewProductView = false
                            
                            //TODO: Save to CloudKit
                            
                            
                        } label: {
                            Text("trailingDone")
                                .font(.system(size: 17))
                                .bold()
                                .foregroundColor(.blue)
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct CreateNewCustomProductView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewCustomProductView(showCreateNewProductView: .constant(false))
    }
}

extension View {
    /// Hide or show the view based on a boolean value.
    ///
    /// Example for visibility:
    ///
    ///     Text("Label")
    ///         .isHidden(true)
    ///
    /// Example for complete removal:
    ///
    ///     Text("Label")
    ///         .isHidden(true, remove: true)
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
