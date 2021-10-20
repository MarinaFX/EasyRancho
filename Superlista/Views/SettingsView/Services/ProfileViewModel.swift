////
////  ProfileViewModel.swift
////  Superlista
////
////  Created by Luiz Eduardo Mello dos Reis on 19/10/21.
////
//
//import SwiftUI
//
//class ProfileViewModel : ObservableObject{
//    @Published var userName: String = ""
//    @Published var isEditingName: Bool = false
//    @Published var showingImagePicker: Bool = false
//    @Published var image: UIImage?
//    
//    private let userService: CKService = CKService()
//
//    
//    func updateUsername(_ newName: String){
//        //atualizar no banco
//        userService.updateUserName(name: newName)
//        isEditingName.toggle()
//    }
//    
//    func updateAvatar(image: UIImage) {
//        if let imageData = image.jpegData(compressionQuality: 0.8) {
//            let imageName = ProcessInfo.processInfo.globallyUniqueString
//            let fileName = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(imageName)
//            
//            guard ((try? imageData.write(to: fileName)) != nil) else {
//                return
//            }
//            //atualizar no banco
//            userService.updateUserImage(imageName: imageName)
//        }
//    }
//    
//    func loadImage(saveIn userProgress: UserProgressViewModel) {
//        guard let newImage = image else { return }
//        
//        updateAvatar(image: newImage, for: userProgress)
//        
//        showingImagePicker = false
//    }
//}
