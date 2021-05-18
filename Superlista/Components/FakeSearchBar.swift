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
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(8)
                .padding(.leading, 30)
                .background(Color(.systemGray6))
                .cornerRadius(50)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .foregroundColor(.gray)
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

