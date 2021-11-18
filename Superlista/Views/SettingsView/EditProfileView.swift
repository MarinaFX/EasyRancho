//
//  EditProfileView.swift
//  Superlista
//
//  Created by Luiz Eduardo Mello dos Reis on 20/10/21.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.sizeCategory) var sizeCategory
    @EnvironmentObject var dataService: DataService

    @Binding var showingSheet: Bool
    @Binding var username: String
    @Binding var picture: UIImage?
    
    @State private var newUsername = ""
    @State private var isShowGallery = false
    
    private var axes: Axis.Set {
        return sizeCategory.isAccessibilityCategory ? .vertical : []
    }
    
    var body: some View {
        NavigationView {
            ScrollView(axes, showsIndicators: false) {
                VStack {
                    Text("EditProfileTitle")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    ZStack {
                        if let picture = picture {
                            Image(uiImage: picture)
                                .resizable()
                                .clipShape(Circle())
                                .scaledToFill()
                                .frame(width:140, height: 140)
                        }
                        else {
                            if let newusername = newUsername{
                                ProfilePicture(username: newusername.isEmpty || newusername == "" ? username : newusername, backgroundColor: Color("ButtonBG"))
                                .padding()
                            }
                        }
                        
                        Button{
                            self.isShowGallery = true
                        } label: {
                            ZStack{
                                Circle()
                                    .stroke()
                                    .frame(width: 140, height: 140)
                                    .foregroundColor(.clear)
                            }
                        }
                        .accessibilityLabel("EditProfileImagePickerLabel")
                        .sheet(isPresented: $isShowGallery) {
                            ImagePicker(image: self.$picture)
                        }
                    }
                    TextField(LocalizedStringKey("EditProfileFieldPlaceholder"), text: $newUsername)
                        .modifier(CustomTextFieldStyle())
                        .accessibilityLabel("EditProfileTextFieldLabel")
                        .accessibilityHint("EditProfileTextFieldHint")
                    
                    Text("EditProfileText")
                        .padding(.horizontal)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.showingSheet = false
                    } label: {
                        Text("EditProfileLeadingNavigationLabel")
                    }
                    
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if newUsername.isEmpty{
                            self.newUsername = dataService.user?.name ?? ""
                        }
                        
                        if let picture = picture {
                            dataService.updateUserImageAndName(picture: picture, newUsername: newUsername)
                        } else {
                            dataService.updateUserName(newUsername: newUsername)
                        }
                        
                        self.username = newUsername
                        self.picture = picture
                        self.showingSheet = false
                    } label: {
                        Text("EditProfileTrailingNavigationLabel")
                    }
                }
            }
        }
    }
}
