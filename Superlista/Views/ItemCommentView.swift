import SwiftUI

struct ItemCommentView: View {
    @State var isCommenting: Bool = false
    @State var comment: String = ""
        
    var item: ItemModel
    
    @Binding var list: ListModel?
    
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
                            if let list = list {
                                let newList = list.toggleCompletion(of: item)
                                self.list = newList
                            }
                        }
                        .accessibilityAddTraits(AccessibilityTraits.isButton)
                        .accessibilityRemoveTraits(AccessibilityTraits.isImage)
                        .accessibilityLabel(Text(item.isCompleted ? "CheckedItemIconLabel1" : "CheckedItemIconLabel2"))
                        .accessibility(hint: Text(item.isCompleted ? "CheckedItemIconHint1" : "CheckedItemIconHint2"))
                    
                    Text(item.product.name)
                        .strikethrough(item.isCompleted)
                        .foregroundColor(item.isCompleted ? Color(UIColor.secondaryLabel) : Color.primary)
                        .font(.body)
                        .fontWeight(.medium)
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
                    
                    QuantityCounter(item: item, list: $list)
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
                                if let list = list {
                                    isCommenting = false
                                    let newList = list.addComment(comment, to: item)
                                    self.list = newList
                                }
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
