import SwiftUI

struct ListHeader: View {
    @ScaledMetric var collabIconWidth: CGFloat = 28
    @ScaledMetric var collabIconHeight: CGFloat = 24
    
    @Binding var listTitle: String
    @State var canComment: Bool = false
    @State var comment: String = ""
    @Binding var canEditTitle: Bool
    @State var showCollabSheetView: Bool = false
    @State var collaborators: [OwnerModel]
    @State var listOwner: OwnerModel
    
    let list: ListModel?
    
    @Binding var listId: String
    
    var body: some View {
        HStack (spacing: 5){
            VStack(alignment: .leading) {
                
                ZStack(alignment: .leading) {
                    if canEditTitle {
                        if listTitle.isEmpty {
                            Text("NovaLista")
                                .foregroundColor(Color("Secondary"))
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .accessibility(hint: Text("ListHeaderTitle"))
                            
                        }
                        
                        TextField("", text: $listTitle)
                            .foregroundColor(canEditTitle ? Color("PrimaryBackground") : .black)
                            .font(.largeTitle)
                            .background(Color("editTitleBackground"))
                            .onTapGesture {
                                if listTitle == NSLocalizedString("NovaLista", comment: "NovaLista") {
                                    listTitle = ""
                                }
                            }
                    }
                    
                    if !canEditTitle {
                        HStack {
                            Text(listTitle)
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
                    .frame(width: collabIconWidth, height: collabIconHeight)
                    .foregroundColor(.black)
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
                listTitle = list.title
                canEditTitle = false
                collaborators = list.sharedWith ?? []
            }
        }
    }
}
