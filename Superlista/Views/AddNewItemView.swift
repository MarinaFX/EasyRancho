//
//  AddNewItemView.swift
//  Superlista
//
//  Created by Marina De Pazzi on 06/05/21.
//

import SwiftUI

struct AddNewItemView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    
    @State var text: String
    
    var body: some View {
        GeometryReader { geometry in
            MainScreen(customView: AnyView(
                        List {
                            ForEach(listViewModel.list) { item in
                                Text(item.product.name)
                            }
                        }
                        .offset(y: geometry.size.height * 0.01)
                        .listStyle(PlainListStyle())
            ))
                
                .toolbar {
                    ToolbarItem(placement: .principal){
                        SearchBar(text: $text)
                            .frame(width: geometry.size.width*0.8, height: geometry.size.width*0.3)
                    }
                }
        }
        
    }
}

struct AddNewItemView_Previews: PreviewProvider {
    @State static var testing: String = ""
    
    static var previews: some View {
        NavigationView {
            GeometryReader { geometry in
                AddNewItemView(text: "flemis")
                    
                    .toolbar{
                        ToolbarItem(placement: .principal){
                            SearchBar(text: $testing)
                                .frame(width: geometry.size.width*0.8)
                        }
                    }
            }
        }
        .environmentObject(ListViewModel())
    }
}
