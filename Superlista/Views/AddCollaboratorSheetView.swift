//
//  AddCollaboratorSheetView.swift
//  Superlista
//
//  Created by Marina De Pazzi on 18/10/21.
//

import SwiftUI

//MARK: - AddCollaboratorSheetView Struct

//TODO: Review and refine adjusments with ux
//TODO: Implement share sheet actions

struct AddCollaboratorSheetView: View {
    @Binding var showCollabSheetView: Bool
    @State var showShareActionSheet: Bool = false
    
    var collaborators = ["Thais Fernandes", "Marina De Pazzi", "Gabriela Zorzo", "Luiz Eduardo", "Julia Bergmann"]
    
    
    //MARK: AddCollaboratorSheetView View
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    Text("Add collaborators to your list so they can make changes in real time")
                    
                    Button(action: {
                        self.showShareActionSheet.toggle()
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
                    .padding(16)
                    
                    
                    List {
                        ForEach(self.collaborators, id: \.self) { item in
                            HStack(alignment: .center, spacing: 16) {
                                Image("cesta")
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 46, height: 46)

                                Text(item)
                                    .bold()
                                
                                Spacer()
                                
                                Button {
                                    self.showShareActionSheet.toggle()
                                } label: {
                                    Image(systemName: "ellipsis.circle")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.black)
                                        
                                }

                            }
                        }
                        .listRowBackground(Color("InsetGroupedBackground"))
                    }
                    .foregroundColor(.black)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.42)
                    .listStyle(.insetGrouped)
                    
                    Text("Or just share your list with your contacts")
                        .font(.system(size: 13))
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                    
                    Button(action: {
                        self.showShareActionSheet.toggle()
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
                    .padding(16)
                    
                    Text("Sharing your list with another person will only send a copy of your list. Your shared list will not be affected and this person **will not** be added as a collaborator")
                        .font(.system(size: 13))
                        .foregroundColor(Color("Footnote"))
                        .padding(16)
                    
                }

                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                self.showCollabSheetView = false
                            } label: {
                                Text("Cancel")
                                    .font(.system(size: 17))
                                    .foregroundColor(.blue)
                            }
                        }
                        
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
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct AddColaboratorSheetView_Previews: PreviewProvider {
    static var previews: some View {
        AddCollaboratorSheetView(showCollabSheetView: .constant(false))
    }
}
