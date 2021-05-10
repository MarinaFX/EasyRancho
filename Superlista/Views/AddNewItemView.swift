//
//  AddNewItemView.swift
//  Superlista
//
//  Created by Marina De Pazzi on 06/05/21.
//

import SwiftUI

struct AddNewItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var listViewModel: ListViewModel
    
    @State var text: String
    
    let products = ProductListViewModel().products
    
    var body: some View {
        GeometryReader { geometry in
            MainScreen(customView: AnyView(
                VStack {
                    List {
                        ForEach(products) { item in
                            HStack {
                                Image(systemName: "plus")
                                Text(item.name)
                            }
                        }
                    }
                    .frame(height: geometry.size.height * 0.92)
                    //.offset(y: geometry.size.height * 0.01)
                    .listStyle(PlainListStyle())
                    
                    Button(action: prontoButtonPressed, label: {
                        Text("Pronto")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(height: geometry.size.height * 0.06)
                            .frame(width: 165)
                            .background(Color.orange)
                            .cornerRadius(30)
                            .shadow(radius: 10)
                    }).padding(.bottom, geometry.size.height * 0.09)
                }
                
            ))
            
            .toolbar {
                ToolbarItem(placement: .principal){
                    SearchBar(text: $text)
                        .frame(width: geometry.size.width*0.8, height: geometry.size.width*0.3)
                    
                }
            }
        }
    }
    
    func prontoButtonPressed(){
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddNewItemView_Previews: PreviewProvider {
    @State static var testing: String = ""
    
    static var previews: some View {
        NavigationView {
            AddNewItemView(text: "")
        }
        .environmentObject(ListViewModel())
    }
}


//MainScreen(customView: AnyView(
//    List {
//        ForEach(0..<listViewModel.categories.count, id: \.self) { category in
//
//            ForEach(listViewModel.rows(from: category)) { item in
//
//                HStack {
//                    Image(systemName: item.isCompleted ? "checkmark" : "plus")
//                        .onTapGesture {
//                            listViewModel.toggleCompletion(of: item, from: category)
//                        }
//                        .animation(.easeInOut(duration: 2.0))
//
//                    Text(item.product.name)
//
//                }
//
//            }.onDelete { row in
//                listViewModel.deleteItem(from: row, of: category)
//            }
//        }
//    }
//    .offset(y: geometry.size.height * 0.01)
//    .listStyle(PlainListStyle())
//))
//
//.toolbar {
//    ToolbarItem(placement: .principal){
//        SearchBar(text: $text)
//            .frame(width: geometry.size.width*0.8, height: geometry.size.width*0.3)
//
//    }
//}


//List {
//    ForEach(0..<listViewModel.categories.count, id: \.self) { category in
//
//        ForEach(listViewModel.rows(from: category)) { item in
//
//            HStack {
//                Image(systemName: item.isCompleted ? "checkmark" : "plus")
//                    .onTapGesture {
//                        listViewModel.toggleCompletion(of: item, from: category)
//                    }
//                    .animation(.easeInOut(duration: 2.0))
//
//                Text(item.product.name)
//
//            }
//        }
//    }
//}
//.offset(y: geometry.size.height * 0.01)
//.listStyle(PlainListStyle())
