//
//  CustomHeader.swift
//  Superlista
//
//  Created by Gabriela Zorzo on 06/05/21.
//

import SwiftUI
import UIKit

struct CustomHeader: View {
    
//    init(){
//            UIView.setAnimationsEnabled(false)
//        }
    
    @State private var goBack = false
    let headerColor = Color("HeaderColor")
    
    var body: some View {
        ZStack{
            headerColor
                .ignoresSafeArea()
            
            ScrollView{
                
                HStack{
                    
//                    Button(action: {
//                        goBack.toggle()
//                    }, label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
//                    })
//                    .fullScreenCover(isPresented: $goBack) {
//                        ProductListView()
//                    }
                    
                    Spacer()
                    
                    Text("Adicionar Capa")
                        .font(.system(size: 24))
                        .bold()
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.white)
                }
                .padding(.leading, 40)
                .padding(.trailing, 30)
                
            }
        }
    }
}

struct CustomHeader_Previews: PreviewProvider {
    static var previews: some View {
        CustomHeader()
    }
}
