import SwiftUI

struct OnboardingFieldsView: View {
    var action: (() -> Void)?
    @State private var newUsername = ""
    @State private var isShowGallery = false
    @State private var goToMainView = false
    @State var username: String = ""
    @Binding var picture: UIImage?
    
    var hasAddedUsername: Bool {
        return newUsername != ""
    }
    
    var hasAddedPicture: Bool {
        return picture != nil
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
                .sheet(isPresented: $isShowGallery) {
                    ImagePicker(image: self.$picture)
                }
            }
            
            #warning("localizable not working")
            TextField("Nome", text: $newUsername)
                .modifier(CustomTextFieldStyle())
            
            Spacer()
            
            Button("Salvar", action: { saveInfos() })
                .buttonStyle(MediumButtonStyle(background: .blue, foreground: .white))
                .padding(.bottom, 48)
            
            NavigationLink("", destination: MainView(), isActive: $goToMainView)
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { saveInfos() }) {
                    Text("Pular")
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
            CKService.currentModel.updateUserImageAndName(image: picture, name: newUsername) { result in }
            
        } else {
            CKService.currentModel.updateUserName(name: newUsername) { result in }
        }
        
        action?()
    }
}
