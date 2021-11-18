import SwiftUI

struct OnboardingFieldsView: View {
    @EnvironmentObject var dataService: DataService
    
    @State private var newUsername = ""
    @State private var isShowGallery = false
    @State var username: String = ""
    @Binding var picture: UIImage?
    
    var hasAddedUsername: Bool {
        return newUsername != ""
    }
    
    var body: some View {
        VStack {
            Text("OnboardingFieldsTitle")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.bottom, 12)
            
            Text("OnboardingFieldsText")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 27)
                .padding(.bottom, 43)
            
            ZStack {
                if let picture = picture {
                    Image(uiImage: picture)
                        .resizable()
                        .clipShape(Circle())
                        .scaledToFill()
                        .frame(width: 140, height: 140)
                        .accessibilityLabel("Foto de perfil")
                } else {
                    UploadPictureButton()
                }
                
                Button {
                    self.isShowGallery = true
                } label: {
                    ZStack{
                        Circle()
                            .stroke()
                            .frame(width: 140, height: 140)
                            .foregroundColor(.white)
                    }
                }
                .accessibilityLabel("Adicionar foto de perfil")
                .sheet(isPresented: $isShowGallery) {
                    ImagePicker(image: self.$picture)
                }
            }
            
            TextField(NSLocalizedString("OnboardingFieldPlaceholder", comment: "OnboardingFieldPlaceholder"), text: $newUsername)
                .modifier(CustomTextFieldStyle())
                .accessibilityLabel("Campo de texto")
                .accessibilityHint("Informe seu nome")
            
            Spacer()
            
            Button("OnboardingBottomButtonLabel", action: { saveInfos() })
                .buttonStyle(MediumButtonStyle(background: .blue, foreground: .white))
                .padding(.bottom, 48)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { saveInfos() }) {
                    Text("OnboardingTrailingNavigationLabel")
                        .underline()
                        .foregroundColor(.blue)
                }
            }
        }
    }
    
    func saveInfos() {
        if newUsername.isEmpty {
            self.newUsername = getNickname()
        }
        
        if hasAddedUsername, let picture = picture {
            dataService.updateUserImageAndName(picture: picture, newUsername: newUsername)

        } else {
            dataService.updateUserName(newUsername: newUsername)
        }
    }
}
