//
//  AddCollaboratorSheetView.swift
//  Superlista
//
//  Created by Marina De Pazzi on 18/10/21.
//

import SwiftUI

//MARK: - AddCollaboratorSheetView Struct

struct AddCollaboratorSheetView: View {
    @Binding var showCollabSheetView: Bool
    @Binding var collaborators: [UserModel]

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
                        Text("Add collaborators to your list so they can make changes in real time")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(EdgeInsets(top: 8, leading: 20, bottom: 16, trailing: 16))
                        
                        Button(action: {
                            guard let list = list else {
                                return
                            }

                            self.showShareActionSheet.toggle()
                            shareSheet(listID: list.id, ownerID: list.owner.id, option: "1", listName: list.title, ownerName: list.owner.name ?? "")
                        }, label: {
                            HStack(alignment: .center) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(Color("Pronto"))
                                
                                Text("Add Collaborator")
                                    .foregroundColor(Color("Pronto"))
                                    .bold()
                                    
                                Spacer()
                            }
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                        })
                        .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.07)
                        .background(Color("InsetGroupedBackground"))
                        .cornerRadius(12)
                        .padding(.horizontal, 16)
                        
                        //MARK: AddCollaboratorSheetView List view
                        if let collaborators = collaborators {
                            List {
                                ForEach(0..<collaborators.count) { index in
                                    HStack(alignment: .center, spacing: 16) {
                                        //TODO: user picture
                                        Image("cesta")
                                            .resizable()
                                            .clipShape(Circle())
                                            .frame(width: 46, height: 46)

                                        Text(collaborators[index].name ?? getNickname())
                                            .bold()
                                        
                                        Spacer()
                                        
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
                                                title: Text("DeleteCollabAlertTitle \(collaborators[index].name ?? getNickname())"),
                                                message: Text("DeleteCollabAlertMessage"),
                                                primaryButton: .destructive(Text("DeleteCollabAlertPrimaryButton"), action: {
                                                    //TODO: Delete Collab
                                                }),
                                                secondaryButton: .cancel(Text("DeleteCollabAlertSecondaryButton"), action: {})
                                            )
                                        }
                                        
                                        
                                    }
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
                                Text("You haven't added any collaborators yet")
                                    .foregroundColor(Color(UIColor.lightGray))
                            }
                            .frame(width: geometry.size.width - 32, height: geometry.size.height * 0.45)
                            .background(Color("InsetGroupedBackground"))
                            .cornerRadius(10)
                            .padding(.vertical, 16)
                        }
                        
                        
                        
                        //MARK: AddCollaboratorSheetView Share section
                        Text("Or just share your list with your contacts")
                            .font(.system(size: 13))
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                        
                        Button(action: {
                            guard let list = list else {
                                return
                            }
                            
                            self.showShareActionSheet.toggle()
                            shareSheet(listID: list.id, ownerID: list.owner.id, option: "2", listName: list.title, ownerName: list.owner.name ?? "")
                        }, label: {
                            HStack(alignment: .center) {
                                Text("Share list")
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
                        
                        Text("Sharing your list with another person will only send a copy of your list. Your shared list will not be affected and this person **will not** be added as a collaborator")
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
                                    Text("Cancel")
                                        .font(.system(size: 17))
                                        .foregroundColor(.blue)
                                }
                            }
                            
                            //MARK: AddCollaboratorSheetView Done button
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    //TODO: CKService.currentModel.save...
                                    self.showCollabSheetView = false
                                } label: {
                                    Text("Done")
                                        .font(.system(size: 17))
                                        .bold()
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .navigationTitle("Add Collaborator")
                        .navigationBarTitleDisplayMode(.large)
                }
            }
        }
        .onAppear {
            CKService.currentModel.refresh { result in }
        }
    }
}
