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
    @Environment(\.sizeCategory) var sizeCategory
    @EnvironmentObject var dataService: DataService
    
    @ScaledMetric var buttonHeight: CGFloat = UIScreen.main.bounds.height * 0.07
    
    @Binding var showCollabSheetView: Bool
    @Binding var collaborators: [OwnerModel]
    @Binding var listOwner: OwnerModel
    
    @State var showShareActionSheet: Bool = false
    @State var showDeleteCollabAlert: Bool = false
    
    let list: ListModel?
    
    let networkMonitor = NetworkMonitor.shared
    
    var ckList: CKListModel? {
        if let list = list {
            return ListModelConverter().convertLocalListToCloud(withList: list)
        }
        return nil
    }
    
    //MARK: AddCollaboratorSheetView View
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack {
                    //MARK: AddCollaboratorSheetView Collab section
                    if let list = list, let user = dataService.user {
                        if dataService.isOwner(of: list, userID: user.id) {
                            Text("AddCollabTextTip")
                                .font(.body)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(EdgeInsets(top: 8, leading: 20, bottom: 16, trailing: 16))
                            
                            Button(action: {
                                self.showShareActionSheet.toggle()
                                shareSheetList(listID: list.id, option: "1", listName: list.title, ownerName: listOwner.name ?? getNickname())
                            }, label: {
                                HStack(alignment: .center) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor((networkMonitor.status == .satisfied) ? Color("Button") : Color(UIColor.secondaryLabel))
                                    
                                    Text("AddCollabButton")
                                        .font(.body)
                                        .foregroundColor((networkMonitor.status == .satisfied) ? Color("Button") : Color(UIColor.secondaryLabel))
                                        .bold()
                                    
                                    Spacer()
                                }
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                            })
                                .frame(width: UIScreen.main.bounds.width * 0.9, height: sizeCategory < ContentSizeCategory.accessibilityExtraExtraExtraLarge ? buttonHeight : UIScreen.main.bounds.height * 0.5, alignment: .leading)
                                .background(Color("InsetGroupedBackground"))
                                .cornerRadius(12)
                                .padding(.horizontal, 16)
                                .disabled(!(networkMonitor.status == .satisfied))
                        } else {
                            Text("ExitCollabTextTip")
                                .font(.body)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(EdgeInsets(top: 8, leading: 20, bottom: 16, trailing: 16))
                        }
                    }
                    
                    //MARK: AddCollaboratorSheetView List view
                    if let collaborators = collaborators {
                        if !collaborators.isEmpty {
                            List {
                                OwnerView(name: listOwner.name ?? getNickname())
                                    .listRowBackground(Color("InsetGroupedBackground"))
                                
                                ForEach(0..<self.collaborators.count, id: \.self) { index in
                                    CollaboratorListView(collaborators: self.$collaborators, list: list, name: collaborators[index].name ?? getNickname(), index: index)
                                }
                                .listRowBackground(Color("InsetGroupedBackground"))
                            }
                            .foregroundColor(.primary)
                            .padding(.vertical, 16)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.45)
                            .listStyle(.insetGrouped)
                        }
                        else {
                            VStack {
                                Text("NoCollaboratorsText")
                                    .foregroundColor(Color(UIColor.lightGray))
                            }
                            .frame(width: UIScreen.main.bounds.width - 40, height: sizeCategory < ContentSizeCategory.accessibilityExtraExtraExtraLarge ? UIScreen.main.bounds.height * 0.45 : UIScreen.main.bounds.height * 0.6)
                            .background(Color("InsetGroupedBackground"))
                            .cornerRadius(10)
                            .padding(.vertical, 16)
                        }
                    }
                    
                    //MARK: AddCollaboratorSheetView Share section
                    Text("ShareListText")
                        .font(.footnote)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    
                    Button(action: {
                        guard let list = list else {
                            return
                        }
                        
                        self.showShareActionSheet.toggle()
                        shareSheetList(listID: list.id, option: "2", listName: list.title, ownerName: listOwner.name ?? getNickname())
                    }, label: {
                        HStack(alignment: .center) {
                            Text("ShareListButton")
                                .font(.body)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.primary)
                                .padding(8)
                        }
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    })
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: sizeCategory < ContentSizeCategory.accessibilityExtraExtraExtraLarge ? buttonHeight : UIScreen.main.bounds.height * 0.5, alignment: .leading)
                        .background(Color("InsetGroupedBackground"))
                        .cornerRadius(12)
                        .padding(.horizontal, 16)
                    
                    Text("ShareListWarning")
                        .font(.footnote)
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
                                .font(.body)
                                .foregroundColor(Color("Button"))
                        }
                    }
                    
                    //MARK: AddCollaboratorSheetView Done button
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            self.showCollabSheetView = false
                        } label: {
                            Text("AddCollaboratorTrailingNavigationLabel")
                                .font(.body)
                                .bold()
                                .foregroundColor(Color("Button"))
                        }
                    }
                }
                .navigationTitle("AddCollabTitle")
                .navigationBarTitleDisplayMode(.large)
            }
        }
        .onAppear {
            CKService.currentModel.refresh { result in }
        }
        .foregroundColor(.primary)
    }
}

// MARK: - Collaborator List View
struct CollaboratorListView: View {
    @EnvironmentObject var dataService: DataService
    
    @Binding var collaborators: [OwnerModel]
    @State var showDeleteCollabAlert: Bool = false
    
    let list: ListModel?
    let name: String
    var collabImage: UIImage?
    var index: Int
    
    let networkMonitor = NetworkMonitor.shared
    
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
                ProfilePicture(username: name, viewWidth: 46, viewHeight: 46, circleWidth: 37, circleHeight: 37, backgroundColor: Color("InsetGroupedBackground"))
            }
            
            Text(name)
                .bold()
            
            Spacer()
            if let list = list, let user = dataService.user {
                if dataService.isOwner(of: list, userID: user.id) {
                    Button {
                        showDeleteCollabAlert = true
                    }
                label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor((networkMonitor.status == .satisfied) ? Color.primary : Color(UIColor.secondaryLabel))
                }
                .alert(isPresented: self.$showDeleteCollabAlert) {
                    Alert(
                        title: Text("DeleteCollabAlertTitle \(collaborators[index].name ?? getNickname())"),
                        message: Text("DeleteCollabAlertMessage"),
                        primaryButton: .destructive(Text("DeleteCollabAlertPrimaryButton"), action: {
                            dataService.removeCollab(of: list, owner: collaborators[index])
                            
                            var newCollabList: [OwnerModel] = collaborators
                            newCollabList.remove(at: index)
                            
                            self.collaborators = newCollabList
                        }),
                        secondaryButton: .cancel(Text("DeleteCollabAlertSecondaryButton"), action: {})
                    )
                }
                .disabled(!(networkMonitor.status == .satisfied))
                }
            }
        }
    }
}

// MARK: - Collaborator List View
struct OwnerView: View {
    let name: String
    var collabImage: UIImage?
    
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
                ProfilePicture(username: name, viewWidth: 46, viewHeight: 46, circleWidth: 37, circleHeight: 37, backgroundColor: Color("InsetGroupedBackground"))
            }
            
            Text(name)
                .bold()
            
            Spacer()

            Text("Owner")
                .foregroundColor(Color(UIColor.secondaryLabel))
        }
    }
}
