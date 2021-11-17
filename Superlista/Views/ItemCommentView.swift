import SwiftUI

//MARK: - ItemCommentView
struct ItemCommentView: View {
    @Environment(\.sizeCategory) var sizeCategory
    @EnvironmentObject var dataService: DataService
    @ScaledMetric var textBubbleHeight: CGFloat = 18
    @ScaledMetric var textBubbleWidth: CGFloat = 18
    
    let networkMonitor = NetworkMonitor.shared
    
    @State var isCommenting: Bool = false
    @State var comment: String = ""
    
    let purpleColor = Color("Background")
    
    var item: ItemModel
    @Binding var list: ListModel?
    
    var body: some View {
        ZStack{
            Color("PrimaryBackground")
                .ignoresSafeArea()
            
            //In case AccessibilityLarge or a bigger mode is being used
            //the accessibility layout is rendered
            if sizeCategory.isAccessibilityCategory {
                VStack(alignment: .leading) {
                    HStack {
                        CheckmarkWithTextView(item: self.item, list: self.$list)
                    }
                    .padding(.top, 16)
                    
                    HStack {
                        ItemQuantityView(item: self.item, list: self.$list)
                    }
                    
                    HStack {
                        if isCommenting {
                            SingleItemCommentView(isCommenting: self.$isCommenting, comment: self.$comment, item: self.item, list: self.$list)
                        } else if item.comment != "" {
                            Text(item.comment ?? "")
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.secondaryLabel))
                                .padding(.leading, 30)
                                .accessibility(hidden: item.comment == "")
                                .accessibility(hint: Text("CommentTextHint \(item.product.name)"))
                        }
                        
                        if !isCommenting {
                            Image(systemName: "text.bubble")
                                .resizable()
                                .frame(width: textBubbleWidth, height: textBubbleHeight)
                                .foregroundColor(Color("Comment"))
                                .onTapGesture {
                                    isCommenting = true
                                }
                                .accessibilityAddTraits(AccessibilityTraits.isButton)
                                .accessibilityRemoveTraits(AccessibilityTraits.isImage)
                                .accessibilityLabel(Text("CommentIconLabel"))
                                .accessibility(hint: Text(comment != "" ? "CommentIconHint1" : "CommentIconHint2"))
                        }
                    }
                }
            }
            else {
                //In case no accessibility mode is being used
                //the original layout is rendered
                VStack (alignment: .leading, spacing: 0) {
                    HStack {
                        CheckmarkWithTextView(item: self.item, list: self.$list)
                        
                        if !isCommenting {
                            Image(systemName: "text.bubble")
                                .resizable()
                                .frame(width: textBubbleWidth, height: textBubbleHeight)
                                .foregroundColor(getForegroundColor(list: list, networkMonitor: networkMonitor) ? Color("Comment") : Color(UIColor.secondaryLabel))
                                .onTapGesture {
                                    if let sharedWith = list?.sharedWith {
                                        if ((networkMonitor.status == .satisfied) || sharedWith.isEmpty) {
                                            isCommenting = true
                                        }
                                    }
                                }
                                .accessibilityAddTraits(AccessibilityTraits.isButton)
                                .accessibilityRemoveTraits(AccessibilityTraits.isImage)
                                .accessibilityLabel(Text("CommentIconLabel"))
                                .accessibility(hint: Text(comment != "" ? "CommentIconHint1" : "CommentIconHint2"))
                        }
                        
                        Spacer()
                        
                        ItemQuantityView(item: self.item, list: self.$list)
                            .padding(.bottom, 16)
                    }
                    
                    if isCommenting {
                        HStack {
                            SingleItemCommentView(isCommenting: self.$isCommenting, comment: self.$comment, item: self.item, list: self.$list)
                        }
                        .padding(.top, 10)
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
}

//MARK: - CheckmarkWithTextView
struct CheckmarkWithTextView: View {
    @EnvironmentObject var dataService: DataService
    
    let networkMonitor = NetworkMonitor.shared
    
    var item: ItemModel
    @Binding var list: ListModel?
    
    var body: some View {
        Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
            .foregroundColor(item.isCompleted ? Color(UIColor.secondaryLabel) : Color.primary)
            .font(.body)
            .onTapGesture {
                if let sharedWith = list?.sharedWith {
                    if ((networkMonitor.status == .satisfied) || sharedWith.isEmpty) {
                        if let list = list {
                            let newList = list.toggleCompletion(of: item)
                            self.list = newList
                        }
                    }
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
            .fontWeight(.bold)
            .accessibility(hint: Text(item.isCompleted ? "CheckedItemLabelHint \(item.product.name)" : ""))
    }
}

//MARK: - ItemQuantityView
struct ItemQuantityView: View {
    @Environment (\.sizeCategory) var sizeCategory
    @EnvironmentObject var dataService: DataService
    
    @ScaledMetric var plusSymbolWidth: CGFloat = 17
    @ScaledMetric var plusSymbolHeight: CGFloat = 17
    @ScaledMetric var minusSymbolWidth: CGFloat = 17
    @ScaledMetric var minusSymbolHeight: CGFloat = 1.5
    
    let networkMonitor = NetworkMonitor.shared
    
    var item: ItemModel
    @Binding var list: ListModel?
    
    var body: some View {
        ZStack {
            Image(systemName: "minus")
                .resizable()
                .frame(width: minusSymbolWidth, height: minusSymbolHeight)
                .foregroundColor((((item.quantity ?? 1) <= 1) || !getForegroundColor(list: list, networkMonitor: networkMonitor)) ? Color(UIColor.secondaryLabel) : Color("Comment"))
        }
        .frame(width: minusSymbolWidth, height: minusSymbolWidth)
        .onTapGesture {
            if let sharedWith = list?.sharedWith {
                if ((networkMonitor.status == .satisfied) || sharedWith.isEmpty) {
                    if let list = list {
                        let newList = list.removeQuantity(of: item)
                        self.list = newList
                    }
                }
            }
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
            .padding(.horizontal, sizeCategory.isAccessibilityCategory ? 12 : 0)
        
        
        Image(systemName: "plus")
            .resizable()
            .frame(width: plusSymbolWidth, height: plusSymbolHeight)
            .foregroundColor(getForegroundColor(list: list, networkMonitor: networkMonitor) ? Color("Comment") : Color(UIColor.secondaryLabel))
            .onTapGesture {
                if let sharedWith = list?.sharedWith {
                    if ((networkMonitor.status == .satisfied) || sharedWith.isEmpty) {
                        if let list = list {
                            let newList = list.addQuantity(of: item)
                            self.list = newList
                        }
                    }
                }
            }
            .accessibilityAddTraits(AccessibilityTraits.isButton)
            .accessibilityRemoveTraits(AccessibilityTraits.isImage)
            .accessibilityLabel(Text("Add"))
            .accessibility(hint: Text("AddOneItem"))
    }
}

//MARK: - SingleItemCommentView
struct SingleItemCommentView: View {
    @Environment(\.sizeCategory) var sizeCategory
    @EnvironmentObject var dataService: DataService
    
    @Binding var isCommenting: Bool
    @Binding var comment: String
    
    var item: ItemModel
    @Binding var list: ListModel?
    
    var body: some View {
        ZStack(alignment: .leading){
            if (comment == "") {
                Text("ItemCommentViewPlaceholder")
                    .foregroundColor(Color(UIColor.secondaryLabel))
                    .font(.footnote)
                    .padding(.leading, sizeCategory.isAccessibilityCategory ? 0 : 30)
                    .accessibility(hidden: true)
            }
            
            TextField(comment , text: $comment)
                .font(.footnote)
                .foregroundColor(Color(UIColor.secondaryLabel))
                .padding(.leading, sizeCategory.isAccessibilityCategory ? 0 : 28)
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
}
