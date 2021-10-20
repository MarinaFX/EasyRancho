//
//  SearchBarView.swift
//  Superlista
//
//  Created by Marina De Pazzi on 06/05/21.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            #warning("Not working this translate for Search Itens")
            TextField("ProcurarItens", text: $text)
                .foregroundColor(Color(UIColor.secondaryLabel))
                .padding(10)
                .padding(.leading, 30)
                .background(Color("searchColor"))
                .cornerRadius(50)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(UIColor.secondaryLabel))
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .padding(.leading, 15)
                        
                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .onTapGesture {
                    self.isEditing = true
                }
            
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""))
    }
}

//            if isEditing {
//                Button(action: {
//                    self.isEditing = false
//                    self.text = ""
//                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                }) {
//                    Text("Cancel")
//                }
//                .padding(.trailing, 10)
//                .transition(.move(edge: .trailing))
//                .animation(.default)
//            }
