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
    @State var showShareActionSheet: Bool = false
    
    var collaborators = ["Thais Fernandes", "Marina De Pazzi", "Gabriela Zorzo", "Luiz Eduardo", "Julia Bergmann"]
    
    
    //MARK: AddCollaboratorSheetView View
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack{
                    Text("Add collaborators to your list so they can make changes in real time")
                        .padding(16)
                    
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
                    .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.05)
                    .background(Color("Secondary"))
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
                        .listRowBackground(Color("Secondary"))
                    }
                    .foregroundColor(.black)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
                    .listStyle(.insetGrouped)
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
            }
            .navigationTitle("Add Collaborator")
        .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

struct AddColaboratorSheetView_Previews: PreviewProvider {
    static var previews: some View {
        AddCollaboratorSheetView(showCollabSheetView: .constant(false))
    }
}
