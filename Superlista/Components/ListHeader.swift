import SwiftUI

struct ListHeader: View {
    @EnvironmentObject var listsViewModel: DataService
    
    @Binding var listaTitulo: String
    @State var canComment: Bool = false
    @State var comentario: String = ""
    @Binding var canEditTitle: Bool
    @State var showCollabSheetView: Bool = false
    @State var collaborators: [UserModel]
    
    let purpleColor = Color("Background")
    let secondary = Color("Secondary")
    let list: ListModel?
    
    @Binding var listId: String
    
    var body: some View {
        HStack (spacing: 5){
            VStack(alignment: .leading){
                
                ZStack(alignment: .leading) {
                    if canEditTitle {
                        if listaTitulo.isEmpty {
                            Text("Nova Lista")
                                .foregroundColor(secondary)
                                .font(.system(size: 24, weight: .bold))
                            
                        }
                        
                        TextField("", text: $listaTitulo)
                            .foregroundColor(canEditTitle ? Color("PrimaryBackground") : .black)
                            .font(.system(size: 24, weight: .bold))
                            .background(Color("editTitleBackground"))
                            .onTapGesture {
                                if listaTitulo == "Nova Lista"{
                                    listaTitulo = ""
                                }
                            }
                    }
                    
                    if !canEditTitle, let list = list {
                        HStack {
                            Text(list.title).font(.system(size: 24, weight: .bold))
                                .lineLimit(2)
                                .foregroundColor(Color.primary)
                            Spacer()
                        }
                        
                    }
                }
                .frame(maxWidth: .infinity)
                
                
            }
            
            Button {
                self.showCollabSheetView.toggle()
            } label: {
                Image(systemName: self.collaborators.isEmpty ? "person.crop.circle.badge.plus" : "person.crop.circle.badge.checkmark")
                    .resizable()
                    .frame(width: 28, height: 24)
                    .foregroundColor(.black)
            }
            .sheet(isPresented: $showCollabSheetView)
            { }
            content: {
                AddCollaboratorSheetView(showCollabSheetView: self.$showCollabSheetView, collaborators: self.$collaborators, list: self.list)
            }
        }
        .padding(.horizontal, 30)
        .onAppear {            
            if let list = list {
                listaTitulo = list.title
                canEditTitle = false
                collaborators = list.sharedWith ?? []
            }
        }
    }
}
