import SwiftUI

struct ItemCommentView: View {
    @EnvironmentObject var listsViewModel: DataService
    
    @State var isCommenting: Bool = false
    @State var comment: String = ""
    
    let purpleColor = Color("Background")

    var item: ItemModel
    var list: ListModel
    
    var body: some View {
        ZStack{
            Color("PrimaryBackground")
                .ignoresSafeArea()
            
            VStack (alignment: .leading, spacing: 0) {
                
                HStack(alignment: .center) {
                    
                    Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                        .foregroundColor(item.isCompleted ? Color(UIColor.secondaryLabel) : Color.primary)
                        .font(.system(size: 18, weight: .light))
                        .onTapGesture {
                            listsViewModel.toggleCompletion(of: item, from: list)
                        }
                    
                    Text(item.product.name)
                        .strikethrough(item.isCompleted)
                        .foregroundColor(item.isCompleted ? Color(UIColor.secondaryLabel) : Color.primary)
                        .font(.system(size: 17, weight: .semibold))
                    
                    
                    if !isCommenting{
                        Image(systemName: "text.bubble")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .foregroundColor(Color("Comment"))
                            .onTapGesture {
                                isCommenting = true
                            }
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Image(systemName: "minus")
                            .resizable()
                            .frame(width: 17, height: (item.quantity! > 1) ? 2 : 1.5)
                            .foregroundColor((item.quantity! > 1) ? Color("Comment") : Color(UIColor.secondaryLabel))
                    }
                    .frame(width: 17, height: 17)
                    .onTapGesture {
                        listsViewModel.removeQuantity(of: item, from: list)
                    }

                    
                    Text("\(item.quantity!)")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color.primary)
                    
                    
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 17, height: 17)
                        .foregroundColor(Color("Comment"))
                        .onTapGesture {
                            listsViewModel.addQuantity(of: item, from: list)
                        }
                    
                }
                
                if isCommenting {
                    HStack {
                        ZStack(alignment: .leading){
                            if (comment == "") {
                                Text("Insira um comentário")
                                    .foregroundColor(Color(UIColor.secondaryLabel))
                                    .font(.system(size: 13))
                                    .padding(.leading, 30)
                            }
                            
                            TextField(comment , text: $comment)
                                .font(.system(size: 13))
                                .foregroundColor(Color(UIColor.secondaryLabel))
                                .padding(.leading, 28)
                        }
                        
                        Spacer()
                        
                        Text("OK")
                            .foregroundColor(Color.primary)
                            .font(.subheadline)
                            .onTapGesture {
                                listsViewModel.addComment(comment, to: item, from: list)
                                isCommenting = false
                            }
                    }
                } else if item.comment != "" {
                    Text(item.comment ?? "")
                        .font(.footnote)
                        .foregroundColor(Color(UIColor.secondaryLabel))
                        .padding(.leading, 30)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("PrimaryBackground"))
            .onAppear {
                self.comment = item.comment ?? ""
            }
            .padding(.vertical, 5)
        }
    }
}
