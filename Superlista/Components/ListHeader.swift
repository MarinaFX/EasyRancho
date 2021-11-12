import SwiftUI

struct ListHeader: View {
    @EnvironmentObject var dataServive: DataService
    
    @Binding var listaTitulo: String
    @State var canComment: Bool = false
    @State var comentario: String = ""
    @Binding var canEditTitle: Bool
    @State var showCollabSheetView: Bool = false
    @State var collaborators: [OwnerModel]
    @State var listOwner: OwnerModel
    
    let purpleColor = Color("Background")
    let secondary = Color("Secondary")
    let list: ListModel?
    
    @Binding var listId: String
    
    var body: some View {
        HStack (spacing: 5){
            VStack(alignment: .leading) {
                
                ZStack(alignment: .leading) {
                    if canEditTitle {
                        if listaTitulo.isEmpty {
                            Text("NovaLista")
                                .foregroundColor(secondary)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .accessibility(hint: Text("ListHeaderTitle"))
                            
                        }
                        
                        TextField("", text: $listaTitulo)
                            .foregroundColor(canEditTitle ? Color("PrimaryBackground") : .black)
                            .font(.largeTitle)
                            .background(Color("editTitleBackground"))
                            .onTapGesture {
                                if listaTitulo == NSLocalizedString("NovaLista", comment: "NovaLista") {
                                    listaTitulo = ""
                                }
                            }
                    }
                    
                    if !canEditTitle, let list = list {
                        HStack {
                            Text(list.title)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .lineLimit(2)
                                .foregroundColor(Color.primary)
                                .accessibility(hint: Text("ListHeaderTitle"))
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
                    .foregroundColor(.primary)
            }
            .accessibility(label: Text(self.collaborators.isEmpty ? "ListHeaderCollabButton1" : "ListHeaderCollabButton2"))
            .sheet(isPresented: $showCollabSheetView) { }
            content: {
                AddCollaboratorSheetView(showCollabSheetView: self.$showCollabSheetView, collaborators: self.$collaborators, listOwner: self.$listOwner, list: self.list)
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
