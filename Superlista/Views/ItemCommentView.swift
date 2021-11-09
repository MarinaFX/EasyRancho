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
                        .accessibilityAddTraits(AccessibilityTraits.isButton)
                        .accessibilityRemoveTraits(AccessibilityTraits.isImage)
                        .accessibilityLabel(Text(item.isCompleted ? "CheckedItemIconLabel1" : "CheckedItemIconLabel2"))
                        .accessibility(hint: Text(item.isCompleted ? "CheckedItemIconHint1" : "CheckedItemIconHint2"))
                    
                    Text(item.product.name)
                        .strikethrough(item.isCompleted)
                        .foregroundColor(item.isCompleted ? Color(UIColor.secondaryLabel) : Color.primary)
                        .font(.body)
                        .fontWeight(.bold)
                        .accessibility(hint: Text(item.isCompleted ? "CheckedItemLabelHint \(item.product.name)" : ""))
                    
                    if !isCommenting {
                        Image(systemName: "text.bubble")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .foregroundColor(Color("Comment"))
                            .onTapGesture {
                                isCommenting = true
                            }
                            .accessibilityAddTraits(AccessibilityTraits.isButton)
                            .accessibilityRemoveTraits(AccessibilityTraits.isImage)
                            .accessibilityLabel(Text("CommentIconLabel"))
                            .accessibility(hint: Text(comment != "" ? "CommentIconHint1" : "CommentIconHint2"))
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Image(systemName: "minus")
                            .resizable()
                            .frame(width: 17, height: ((item.quantity ?? 1) > 1) ? 2 : 1.5)
                            .foregroundColor(((item.quantity ?? 1) > 1) ? Color("Comment") : Color(UIColor.secondaryLabel))
                    }
                    .frame(width: 17, height: 17)
                    .onTapGesture {
                        listsViewModel.removeQuantity(of: item, from: list)
                    }
                    .accessibilityAddTraits(AccessibilityTraits.isButton)
                    .accessibilityRemoveTraits(AccessibilityTraits.isImage)
                    .accessibilityLabel(Text("Remove"))
                    .accessibility(hint: Text("RemoveOneItem"))
                    
                    
                    Text("\(item.quantity ?? 1)")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(Color.primary)
                        .accessibilityLabel(Text((item.quantity ?? 1) == 1 ? "ItemQuantityLabel1" : "ItemQuantityLabel2 \(item.quantity ?? 1)"))
                        .accessibility(hint: Text("ItemQuantityHint"))

                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 17, height: 17)
                        .foregroundColor(Color("Comment"))
                        .onTapGesture {
                            listsViewModel.addQuantity(of: item, from: list)
                        }
                        .accessibilityAddTraits(AccessibilityTraits.isButton)
                        .accessibilityRemoveTraits(AccessibilityTraits.isImage)
                        .accessibilityLabel(Text("Add"))
                        .accessibility(hint: Text("AddOneItem"))
                    
                }
                
                if isCommenting {
                    HStack {
                        ZStack(alignment: .leading){
                            if (comment == "") {
                                Text("ItemCommentViewPlaceholder")
                                    .foregroundColor(Color(UIColor.secondaryLabel))
                                    .font(.footnote)
                                    .padding(.leading, 30)
                                    .accessibility(hidden: true)
                            }
                            
                            TextField(comment , text: $comment)
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.secondaryLabel))
                                .padding(.leading, 28)
                                .accessibilityLabel(Text("CommentTextFieldLabel"))
                                .accessibility(hint: Text("CommentTextFieldHint"))
                        }
                        
                        Spacer()
                        
                        Text("ItemCommentViewButtonLabel")
                            .foregroundColor(Color.primary)
                            .font(.subheadline)
                            .onTapGesture {
                                listsViewModel.addComment(comment, to: item, from: list)
                                isCommenting = false
                            }
                            .accessibilityAddTraits(AccessibilityTraits.isButton)
                            .accessibilityRemoveTraits(AccessibilityTraits.isImage)
                            .accessibility(hint: Text("CommentConfirmationButtonHint"))

                    }
                } else if item.comment != "" {
                    Text(item.comment ?? "")
                        .font(.footnote)
                        .foregroundColor(Color(UIColor.secondaryLabel))
                        .padding(.leading, 30)
                        .accessibility(hidden: item.comment == "")
                        .accessibility(hint: Text("CommentTextHint \(item.product.name)"))

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
