//
//  FakeSearchBar.swift
//  Superlista
//
//  Created by Gabriela Zorzo on 12/05/21.
//

import SwiftUI

struct FakeSearchBar: View {
    var body: some View {
        HStack {
            Text("Adicionar novos itens")
                .foregroundColor(Color(UIColor.secondaryLabel))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(8)
                .padding(.leading, 30)
                .background(Color("searchColor"))
                .cornerRadius(50)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(UIColor.secondaryLabel))
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .padding(.leading, 15)
                    }
                )
        }
    }
}

struct FakeSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        FakeSearchBar()
    }
}

