//
//  CreateNewCustomProductView.swift
//  Superlista
//
//  Created by Marina De Pazzi on 29/10/21.
//

import SwiftUI

struct CreateNewCustomProductView: View {
    @Environment(\.sizeCategory) var sizeCategory
    
    @ScaledMetric var textViewHeight: CGFloat = UIScreen.main.bounds.height * 0.1
    @ScaledMetric var buttonHeight: CGFloat = UIScreen.main.bounds.width * 0.15
    
    @Binding var showCreateNewProductView: Bool
    
    @State var productName: String = ""
    @State private var lastSelectedItem: Int?
    @State var didFillNameTextField: Bool = false
    @State var didFillCategoryTextField: Bool = false
    
    let categories: [String] = loadCategoryKeys()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .center) {
                    Text("createProductScreenTitle")
                        .font(.title)
                        .bold()
                        .padding(.top, 16)
                    
                    Text("createProductDescription")
                        .font(.body)
                        .padding(EdgeInsets(top: 8, leading: 16, bottom: 24, trailing: 16))
                        .multilineTextAlignment(.center)
                    
                    Text("textFieldRequired")
                        .opacity(didFillNameTextField == true ? 0.0 : 1.0)
                        .font(.callout)
                        .foregroundColor(.red)
                        .padding(.bottom, -24)
                        .padding(.trailing,
                                 sizeCategory > ContentSizeCategory.accessibilityExtraLarge ?
                                 UIScreen.main.bounds.width * 0.25 :
                                    (sizeCategory < ContentSizeCategory.extraExtraLarge ? UIScreen.main.bounds.width * 0.6 : UIScreen.main.bounds.width * 0.55)
                                 )
                        .accessibility(hidden: true)
                    
                    //MARK: CreateNewCustomProductView Form section
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
                        .padding(.bottom, -16)
                        .accessibilityHint("ACtextFieldRequiredHint")
                    
                    PickerTextField(lastSelectedIndex: self.$lastSelectedItem, data: categories, placeholder: NSLocalizedString("productCategoryTextField", comment: "")
                    )
                        .lineLimit(2)
                        .modifier(CustomTextFieldStyle())
                        .frame(height: textViewHeight)
                        .accessibilityLabel("ACpickerFieldLabel")
                        .accessibilityValue("ACpickerFieldValue")
                        .accessibilityHint("ACtextFieldRequiredHint")
                    
                    Spacer()
                    
                    //MARK: CreateNewCustomProductView - Bottom Button
                    Button {
                        guard let lastSelectedItem = lastSelectedItem else {
                            return
                        }
                        
                        let localCustomProduct: ProductModel = ProductModel(id: 999, name: productName, category: categories[lastSelectedItem])
                        
                        //MARK: CreateNewCustomProductView update users product list on cloud
                        if didFillNameTextField {
                            CloudIntegration().updateUserCustomProducts(withProduct: localCustomProduct)
                            
                            self.showCreateNewProductView = false
                        }

                    } label: {
                        Text("trailingDone")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                            .accessibilityHint("ACDoneButtonHint")

                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: buttonHeight)
                    .background(Color("InsetGroupedBackground"))
                    .cornerRadius(14)
                    .padding(.bottom, 20)
                    
                }
                .frame(maxWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height * 0.85)

                
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            self.showCreateNewProductView = false
                        } label: {
                            Text("leadingCancel")
                                .font(.system(size: 17))
                                .foregroundColor(.blue)
                                .accessibilityHint("ACCancelButtonHint")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            guard let lastSelectedItem = lastSelectedItem else {
                                return
                            }
                            
                            let localCustomProduct: ProductModel = ProductModel(id: 999, name: productName, category: categories[lastSelectedItem])
                            
                            //MARK: CreateNewCustomProductView update users product list on cloud
                            if didFillNameTextField {
                                CloudIntegration().updateUserCustomProducts(withProduct: localCustomProduct)
                                
                                self.showCreateNewProductView = false
                            }
                            
                            
                        } label: {
                            Text("trailingDone")
                                .font(.system(size: 17))
                                .bold()
                                .foregroundColor(.blue)
                                .accessibilityHint("ACDoneButtonHint")
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

