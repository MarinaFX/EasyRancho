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
    @State var selectedCategory: String = ""
    @State private var lastSelectedItem: Int?
    
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
                    
                    TextField(NSLocalizedString("productNameTextField", comment: ""), text: $productName)
                        .modifier(CustomTextFieldStyle())
                        .padding(.bottom, -12)
                    
                    PickerTextField(lastSelectedIndex: self.$lastSelectedItem, data: categories, placeholder: NSLocalizedString("productCategoryTextField", comment: ""))
                        .modifier(CustomTextFieldStyle())
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.1)
                    
                    Spacer()
                    
                    //MARK: CreateNewCustomProductView - Bottom Button
                    Button {
                        //TODO: Save to CloudKit
                        self.showCreateNewProductView = false

                        guard let lastSelectedItem = lastSelectedItem else {
                            return
                        }

                        print(categories[lastSelectedItem])
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
