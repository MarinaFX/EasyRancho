//
//  AddCollaboratorSheetView.swift
//  Superlista
//
//  Created by Marina De Pazzi on 18/10/21.
//

import SwiftUI
import CloudKit

//MARK: - AddCollaboratorSheetView Struct

struct AddCollaboratorSheetView: View {
    @EnvironmentObject var dataService: DataService
    
    @Binding var showCollabSheetView: Bool
    @Binding var collaborators: [OwnerModel]
    @Binding var listOwner: OwnerModel
    
    @State var showShareActionSheet: Bool = false
    @State var showDeleteCollabAlert: Bool = false
    
    let list: ListModel?
    
    var ckList: CKListModel? {
        if let list = list {
            return ListModelConverter().convertLocalListToCloud(withList: list)
        }
        return nil
    }
    
    //MARK: AddCollaboratorSheetView View
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ScrollView(showsIndicators: false) {
                    VStack {
                        //MARK: AddCollaboratorSheetView Collab section
                        if dataService.isOwner(of: list!, userID: dataService.user!.id) {
                            Text("AddCollabTextTip")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(EdgeInsets(top: 8, leading: 20, bottom: 16, trailing: 16))
                            
                            Button(action: {
                                guard let list = list else {
                                    return
                                }
                                
                                self.showShareActionSheet.toggle()
                                shareSheet(listID: list.id, option: "1", listName: list.title, ownerName: listOwner.name!)
                            }, label: {
                                HStack(alignment: .center) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(Color("Button"))
                                    
                                    Text("AddCollabButton")
                                        .foregroundColor(Color("Button"))
                                        .bold()
                                    
                                    Spacer()
                                }
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                            })
                                .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.07)
                                .background(Color("InsetGroupedBackground"))
                                .cornerRadius(12)
                                .padding(.horizontal, 16)
                        } else {
                            Text("ExitCollabTextTip")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(EdgeInsets(top: 8, leading: 20, bottom: 16, trailing: 16))
                        }
                        
                        //MARK: AddCollaboratorSheetView List view
                        if let collaborators = collaborators {
                            if !collaborators.isEmpty {
                                List {
                                    ForEach(0..<self.collaborators.count, id: \.self) { index in
                                        CollaboratorListView(collaborators: self.$collaborators, list: list, name: collaborators[index].name!, index: index)
                                    }
                                    .listRowBackground(Color("InsetGroupedBackground"))
                                }
                                .foregroundColor(.black)
                                .padding(.vertical, 16)
                                .frame(width: geometry.size.width, height: geometry.size.height * 0.45)
                                .listStyle(.insetGrouped)
                            }
                            else {
                                VStack {
                                    Text("NoCollaboratorsText")
                                        .foregroundColor(Color(UIColor.lightGray))
                                }
                                .frame(width: geometry.size.width - 32, height: geometry.size.height * 0.45)
                                .background(Color("InsetGroupedBackground"))
                                .cornerRadius(10)
                                .padding(.vertical, 16)
                            }
                        }
                        
                        
                        //MARK: AddCollaboratorSheetView Share section
                        Text("ShareListText")
                            .font(.system(size: 13))
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                        
                        Button(action: {
                            guard let list = list else {
                                return
                            }
                            
                            self.showShareActionSheet.toggle()
                            shareSheet(listID: list.id, option: "2", listName: list.title, ownerName: listOwner.name!)
                        }, label: {
                            HStack(alignment: .center) {
                                Text("ShareListButton")
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(.black)
                                    .padding(8)
                            }
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                        })
                            .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.07)
                            .background(Color("InsetGroupedBackground"))
                            .cornerRadius(12)
                            .padding(.horizontal, 16)
                        
                        Text("ShareListWarning")
                            .font(.system(size: 13))
                            .foregroundColor(Color("Footnote"))
                            .padding(.horizontal, 16)
                    }
                    
                    //MARK: AddCollaboratorSheetView Navbar config
                    .toolbar {
                        //MARK: AddCollaboratorSheetView Cancel button
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                self.showCollabSheetView = false
                            } label: {
                                Text("AddCollaboratorLeadingNavigationLabel")
                                    .font(.system(size: 17))
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        //MARK: AddCollaboratorSheetView Done button
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                self.showCollabSheetView = false
                            } label: {
                                Text("AddCollaboratorTrailingNavigationLabel")
                                    .font(.system(size: 17))
                                    .bold()
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .navigationTitle("AddCollabTitle")
                    .navigationBarTitleDisplayMode(.large)
                }
            }
        }
        .onAppear {
            CKService.currentModel.refresh { result in }
        }
    }
}


struct CollaboratorListView: View {
    @EnvironmentObject var dataService: DataService
    
    @Binding var collaborators: [OwnerModel]
    @State var showDeleteCollabAlert: Bool = false
    
    let list: ListModel?
    let name: String
    var collabImage: UIImage?
    var index: Int
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            //TODO: user picture
            if let collabImage = collabImage {
                Image(uiImage: collabImage)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 46, height: 46)
            }
            else {
                ProfilePicture(username: name, viewWidth: 46, viewHeight: 46, circleWidth: 37, circleHeight: 37)
            }
            
            Text(name)
                .bold()
            
            Spacer()
            
            if dataService.isOwner(of: list!, userID: dataService.user!.id) {
                Button {
                    showDeleteCollabAlert = true
                }
            label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.black)
            }
            .alert(isPresented: self.$showDeleteCollabAlert) {
                Alert(
                    title: Text("DeleteCollabAlertTitle \(collaborators[index].name!)"),
                    message: Text("DeleteCollabAlertMessage"),
                    primaryButton: .destructive(Text("DeleteCollabAlertPrimaryButton"), action: {
                        guard let list = list else { return }
                        
                        dataService.removeCollab(of: list, owner: collaborators[index])
                        
                        var newCollabList: [OwnerModel] = collaborators
                        newCollabList.remove(at: index)
                        
                        self.collaborators = newCollabList
                    }),
                    secondaryButton: .cancel(Text("DeleteCollabAlertSecondaryButton"), action: {})
                )
            }
            }
        }
    }
}
