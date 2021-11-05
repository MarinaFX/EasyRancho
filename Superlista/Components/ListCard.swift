//
//  ListCard.swift
//  Superlista
//
//  Created by Thaís Fernandes on 04/11/21.
//

import SwiftUI

struct ListCard: View {
    @EnvironmentObject var dataService: DataService
    
    var isEditing: Bool
    
    @State var showAlertDelete = false
    @State var showAlertDuplicate = false
    @State var editNavigation = false
    
    var list: ListModel
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            Rectangle()
                .fill(Color("Background"))
                .frame(width: 171, height: 117)
                .cornerRadius(30)
                .shadow(color: Color("Shadow"), radius: 12)
            
            if isEditing {
                Image(systemName: "minus.circle.fill")
                    .font(.title2)
                    .foregroundColor(Color(.systemGray))
                    .offset(x: 150, y: -45)
                    .onTapGesture {
                        dataService.currentList = list
                        showAlertDelete = true
                    }
            }
            
            VStack(alignment: .leading) {
                Text(list.title)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                if let listOwner = list.owner.name {
                    Text(listOwner == dataService.user?.name ? "CriadaPorMim" : "CriadaPor \(String(describing: listOwner))")
                        .font(.footnote)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .padding(.bottom, 25)
                }
                
                HStack {
                    HStack (alignment: .bottom) {
                        if let sharedList = list.sharedWith {
                            if !sharedList.isEmpty {
                                Image(systemName: "person.2.fill")
                                    .font(.body)
                                
                                Text(sharedList.isEmpty ? "0" : (String(describing: sharedList.count)))
                                    .font(.footnote)
                                    .lineLimit(1)
                                    .padding(.trailing)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    if !isEditing {
                        OtherOptionsButton(showAlertDelete: $showAlertDelete, showAlertDuplicate: $showAlertDuplicate, editNavigation: $editNavigation, list: list)
                    }
                }
                .frame(height: 24)

            }
            .padding(.horizontal, 20)
            
            NavigationLink(destination: ListView(listId: dataService.currentList?.id ?? "123"), isActive: $editNavigation) {
                EmptyView()
            }
            
            ZStack {}
            .alert(isPresented: $showAlertDelete){
                Alert(title: Text("Remover \(dataService.currentList!.title)"), message: Text("DeleteListAlertText"), primaryButton: .cancel(), secondaryButton: .destructive(Text("DeleteListAlertButton"), action:{
                    dataService.removeList(dataService.currentList!)
                    showAlertDelete = false
                }))
            }
            
            ZStack {}
            .alert(isPresented: $showAlertDuplicate){
                Alert(title: Text("Duplicar \(dataService.currentList!.title)"), message: Text("DuplicateListAlertText"), primaryButton: .cancel(), secondaryButton: .default(Text("DuplicateListAlertButton"), action:{
                    dataService.duplicateList(of: dataService.currentList!)
                    showAlertDuplicate = false
                }))
            }
            
        }
        .foregroundColor(Color.white)
        
    }
}

struct OtherOptionsButton: View {
    @EnvironmentObject var dataService: DataService
    
    @Binding var showAlertDelete: Bool
    @Binding var showAlertDuplicate: Bool
    @Binding var editNavigation: Bool
    
    var list: ListModel
    
    var body: some View {
        ZStack {
            Image(systemName: "ellipsis.circle.fill")
                .font(.body)
                .contextMenu {
                    Button {
                        dataService.currentList = list
                        editNavigation = true
                    } label: {
                        Label("ContextMenu1", systemImage: "pencil")
                    }
                    Button {
                        dataService.currentList = list
                        showAlertDuplicate = true
                    } label: {
                        Label("ContextMenu2", systemImage: "doc.on.doc")
                    }
                    Button {
                        guard let ownerName = list.owner.name else { return }
                        shareSheet(listID: list.id, option: "1", listName: list.title, ownerName: ownerName)
                    } label: {
                        Label("ContextMenu3", systemImage: "person.crop.circle.badge.plus")
                    }
                    Button {
                        guard let ownerName = list.owner.name else { return }
                        shareSheet(listID: list.id, option: "2", listName: list.title, ownerName: ownerName)
                    } label: {
                        Label("ContextMenu4", systemImage: "square.and.arrow.up")
                    }
                    Button {
                        dataService.currentList = list
                        showAlertDelete = true
                    } label: {
                        Label("ContextMenu5", systemImage: "trash")
                    }
                }
        }
    }
}
