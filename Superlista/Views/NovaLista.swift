//
//  NovaLista.swift
//  Superlista
//
//  Created by Gabriela Zorzo on 06/05/21.
//

import SwiftUI

struct NovaLista: View {
    
    @State var listaTitulo: String = ""
    
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                TextField("Nova Lista", text: $listaTitulo)
                    .font(.system(size: 24))
                    .foregroundColor(Color.black)
                    
                
            }
            .padding(30)
        }
    }
}

struct NovaLista_Previews: PreviewProvider {
    static var previews: some View {
        NovaLista()
    }
}
