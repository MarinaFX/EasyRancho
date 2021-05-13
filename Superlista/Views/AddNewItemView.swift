//
//  AddNewItemView.swift
//  Superlista
//
//  Created by Marina De Pazzi on 06/05/21.
//

import SwiftUI

struct AddNewItemView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var listsViewModel: ListsViewModel
    
    var list: ListModel
    
    @State var selectedProducts: Array<ProductModel> = []
    @State var searchText: String
    
    let products = ProductListViewModel().productsOrdered
    
    var body: some View {
        GeometryReader { geometry in
            MainScreen(customView: AnyView(
                VStack {
                    ProductListView(selectedItems: $selectedProducts, filter: $searchText)
                    
                    Button(action: prontoButtonPressed, label: {
                        Text("Pronto")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(height: geometry.size.height * 0.06)
                            .frame(width: geometry.size.height * 0.25)
                            .background(Color.orange)
                            .cornerRadius(30)
                            .shadow(color: Color.orange.opacity(0.5), radius: 10)
                    })
                    .padding(.bottom, geometry.size.height * 0.12)
                    .padding(.top, geometry.size.height * (0.01))
                    
                }
                
            ))
            
            .toolbar {
                ToolbarItem(placement: .principal){
                    SearchBar(text: $searchText)
                        .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.3)
                }
            }
        }
    }
    
    func prontoButtonPressed(){
        listsViewModel.addItem(selectedProducts[0], to: list)
        listsViewModel.addItem(selectedProducts[1], to: list)
        listsViewModel.addItem(selectedProducts[2], to: list)
        presentationMode.wrappedValue.dismiss()
    }
}

//struct AddNewItemView_Previews: PreviewProvider {
//    @State static var testing: String = ""
//
//    static var previews: some View {
//        NavigationView {
//            AddNewItemView(searchText: "")
//                .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
//                .previewDisplayName("iPhone 12")
//        }
//
//    }
//}
