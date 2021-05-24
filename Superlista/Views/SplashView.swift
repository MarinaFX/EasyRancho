//
//  SplashView.swift
//  Superlista
//
//  Created by Gabriela Zorzo on 24/05/21.
//

import SwiftUI

struct SplashView: View {
    @State var isActive:Bool = false
    
    var body: some View {
            VStack {
                if self.isActive {
                    GridListView()
                } else {
                    VStack{
                        Spacer()
                        Image("DefaultLS")
                            .resizable()
                            .ignoresSafeArea()
                            .scaledToFill()
                        Spacer()
                    }
                }
            }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
    
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}