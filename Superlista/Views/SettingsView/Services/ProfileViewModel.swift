//
//  ProfileViewModel.swift
//  Superlista
//
//  Created by Luiz Eduardo Mello dos Reis on 19/10/21.
//

import SwiftUI

class ProfileViewModel : ObservableObject {
    @Published var userName: String = ""
    @Published var showingImagePicker: Bool = false
    @Published var image: UIImage?
    
    
    func updateUsername(_ newName: String){
        //atualizar no banco
        CKService.currentModel.updateUserName(name: newName) {result in}
    }
    
    func updateAvatar(image: UIImage) {
        //atualizar no banco
        CKService.currentModel.updateUserImage(image: image) {result in}
    }
}
