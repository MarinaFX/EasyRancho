import SwiftUI

struct OnboardingFields: View {

    @State var newUsername: String = ""
    
    var body: some View {
        NavigationView {
            VStack{
                Text("Personalize Seu Perfil")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .multilineTextAlignment(.center)
                
                Text("Adicione um nome e uma foto ao seu perfil para que você possa ser identificado mais facilmente.")
                    .font(.title3)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)

                ProfilePicture(username: "Luiz")
                    .padding()
                
                TextField("Nome", text: $newUsername)
                    .padding(20)
                    .foregroundColor(.black)
                    .background(Color("ButtonBG"))
                    .cornerRadius(15)
                    .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 1.0)))
                    .padding(20)
                
                
                Spacer()
                
//                MediumButton(action: {
//                    print("hello")
//                }, text: "Salvar", backgroundColor: .blue, foregroundColor: .white)
            }
            .navigationBarItems(trailing: Button(action: {
                    print("aaa")
            }) {
                Text("Pular").underline()
            })
            .padding(.bottom, 47)
        }
    }
}

struct OnboardingFields_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingFields()
        
    }
}
