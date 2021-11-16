//
//  ListCard.swift
//  Superlista
//
//  Created by Thaís Fernandes on 09/11/21.
//

import SwiftUI

struct ListCard: View {
    @EnvironmentObject var dataService: DataService
    @Environment(\.sizeCategory) var sizeCategory
    
    let list: ListModel
    let isEditing: Bool
    var alignmentCard: Alignment = .leading
    
    @State var showAlertDelete = false
    @State var editNavigation = false
    @State var showAlertDuplicate = false
    
    let networkMonitor = NetworkMonitor.shared
    
    @ScaledMetric var scaledWidthtRect: CGFloat = 171
    @ScaledMetric var scaledHeightRect: CGFloat = 117
    
    @ScaledMetric(relativeTo: .callout) var scaledTitle: CGFloat = 10
    
    var body: some View {
        NavigationLink(destination: ListView(listId: list.id, list: list), label: {
            ZStack(alignment: .leading) {
                // MARK: - list card
                Rectangle()
                    .fill(Color("Background"))
                    .frame(width: sizeCategory >= ContentSizeCategory.accessibilityExtraLarge ? UIScreen.main.bounds.width * 0.92 : scaledWidthtRect, height: scaledHeightRect)
                    .cornerRadius(30)
                    .shadow(color: Color("Shadow"), radius: 12)
                    .accessibility(hint: Text("HintListCard"))
                
                VStack(alignment: .leading){
                    // MARK: - list title
                    Text(list.title)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                        .lineLimit(1)
                        .padding(.horizontal, 20)
                    
                    //MARK: - List Owner
                    if let listOwner = list.owner.name{
                        Text(listOwner == dataService.user?.name ? "CriadaPorMim" : "CriadaPor \(String(describing: listOwner))")
                            .font(.footnote)
                            .foregroundColor(Color.white)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .padding(.bottom, 25)
                            .padding(.horizontal, 20)
                    }
                    HStack{
                        HStack (alignment: .bottom) {
                            if let sharedList = list.sharedWith {
                                if !sharedList.isEmpty {
                                    Image(systemName: "person.2.fill")
                                        .font(.body)
                                        .foregroundColor(Color.white)
                                    
                                    Text(sharedList.isEmpty ? "0" : (String(describing: sharedList.count)))
                                        .font(.footnote)
                                        .foregroundColor(Color.white)
                                        .lineLimit(1)
                                        .padding(.trailing)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: "ellipsis.circle.fill")
                            .font(.body)
                            .foregroundColor(Color.white)
                            .contextMenu {
                                Button {
                                    dataService.currentList = list
                                    editNavigation = true
                                } label: {
                                    Label("ContextMenu1", systemImage: "pencil")
                                }
                                .accessibility(hidden: false)
                                .accessibilityLabel(Text("Option1"))
                                .accessibility(hint: Text("Option1Hint"))
                                
                                Button {
                                    dataService.currentList = list
                                    showAlertDuplicate = true
                                } label: {
                                    Label("ContextMenu2", systemImage: "doc.on.doc")
                                }
                                .accessibilityLabel(Text("Option2"))
                                .accessibility(hint: Text("Option2Hint"))
                                
                                if let user = dataService.user {
                                    if dataService.isOwner(of: list, userID: user.id) && (networkMonitor.status == .satisfied) {
                                        Button {
                                            guard let ownerName = list.owner.name else { return }
                                            shareSheet(listID: list.id, option: "1", listName: list.title, ownerName: ownerName)
                                        } label: {
                                            Label("ContextMenu3", systemImage: "person.crop.circle.badge.plus")
                                        }
                                        .accessibilityLabel(Text("Option3"))
                                        .accessibility(hint: Text("Option3Hint"))
                                    }
                                }
                                
                                Button {
                                    guard let ownerName = list.owner.name else { return }
                                    shareSheet(listID: list.id, option: "2", listName: list.title, ownerName: ownerName)
                                } label: {
                                    Label("ContextMenu4", systemImage: "square.and.arrow.up")
                                }
                                .accessibilityLabel(Text("Option4"))
                                .accessibility(hint: Text("Option4Hint"))
                                
                                if let sharedWith = list.sharedWith {
                                    if (networkMonitor.status == .satisfied) || sharedWith.isEmpty {
                                        Button {
                                            dataService.currentList = list
                                            showAlertDelete = true
                                        } label: {
                                            Label("ContextMenu5", systemImage: "trash")
                                        }
                                        .accessibilityLabel(Text("Option5"))
                                        .accessibility(hint: Text("Option5Hint"))
                                    }
                                }
                            }
                            .accessibilityLabel(Text("Options"))
                            .accessibility(hint: Text("MoreOptions"))
                    }
                    .padding(.horizontal, 20)
                    
                }
                
                ZStack {
                    NavigationLink(destination: ListView(listId: dataService.currentList?.id ?? "123"), isActive: $editNavigation) {
                        EmptyView()
                    }
                }
                .alert(isPresented: $showAlertDelete){
                    let title = (dataService.currentList != nil) ? dataService.currentList?.title : ""
                    
                    let text = "\(NSLocalizedString("Remover", comment: "Remover")) \(String(describing: title))?";
                    
                    return Alert(title: Text(text), message: Text("DeleteListAlertText"), primaryButton: .cancel(), secondaryButton: .destructive(Text("DeleteListAlertButton"), action: {
                        if let currentList = dataService.currentList {
                            dataService.removeList(currentList)
                            showAlertDelete = false
                        }
                    }))
                }
                
                ZStack {}
                .alert(isPresented: $showAlertDuplicate){
                    let title = (dataService.currentList != nil) ? dataService.currentList?.title : ""
                    
                    let text = "\(NSLocalizedString("Duplicar", comment: "Duplicar")) \(String(describing: title))?";
                    
                    return Alert(title: Text(text), message: Text("DuplicateListAlertText"), primaryButton: .cancel(), secondaryButton: .default(Text("DuplicateListAlertButton"), action: {
                        if let currentList = dataService.currentList {
                            dataService.duplicateList(of: currentList)
                            showAlertDuplicate = false
                        }
                    }))
                }
                
                if isEditing {
                    if let sharedWith = list.sharedWith {
                        if (networkMonitor.status == .satisfied) || sharedWith.isEmpty {
                            Image(systemName: "minus.circle.fill")
                                .font(.title2)
                                .foregroundColor(Color(.systemGray))
                                .offset(x: 150, y: -45)
                                .onTapGesture {
                                    dataService.currentList = list
                                    showAlertDelete = true
                                }
                                .accessibility(label: Text("LabelMinusCircle"))
                                .accessibility(hint: Text("HintMinusCircle"))
                                .accessibility(addTraits: .isButton)
                                .accessibility(removeTraits: .isImage)
                        }
                    }
                }
            }
            .frame(width: sizeCategory >= ContentSizeCategory.accessibilityExtraLarge ? UIScreen.main.bounds.width * 0.92 : scaledWidthtRect, height: scaledHeightRect)
            
        }
        )
    }
}


