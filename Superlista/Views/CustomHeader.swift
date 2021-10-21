import SwiftUI
import UIKit

struct CustomHeader: View {
    @State private var goBack = false
    
    let headerColor = Color("HeaderColor")
    
    var body: some View {
        ZStack{
            headerColor
                .ignoresSafeArea()
            
            ScrollView {
                
                HStack {
                    
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                    
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
