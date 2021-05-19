//
//  ItemCommentView.swift
//  Superlista
//
//  Created by Gabriela Zorzo on 12/05/21.
//

import SwiftUI

struct ItemCommentView: View {
    @EnvironmentObject var listsViewModel: ListsViewModel
    
    let purpleColor = Color("HeaderColor")
    @State var isCommenting: Bool = false
    @State var comment: String = ""
    
    var item: ItemModel
    var list: ListModel
    
    var body: some View {
        
        VStack (alignment: .leading, spacing: 0) {
            
            HStack(alignment: .center) {
                
                Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                    .foregroundColor(Color.primary)
                    .font(.system(size: 18, weight: .light))
                    .onTapGesture {
                        listsViewModel.toggleCompletion(of: item, from: list)
                    }
                
                Text(item.product.name)
                    .foregroundColor(Color.primary)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                
                Spacer()
                
                if !isCommenting{
                    Image(systemName: "text.bubble")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundColor(Color("Comment"))
                        .onTapGesture {
                            isCommenting = true
                        }
                }
                
            }
            
            if isCommenting {
                HStack {
                    TextField(comment == "" ? "Insira um comentário" : comment, text: $comment)
                        .font(.footnote)
                        .foregroundColor(Color(UIColor.secondaryLabel))
                        .padding(.leading, 30)
                    
                    Spacer()
                    
                    Text("OK")
                        .foregroundColor(Color.primary)
                        .font(.subheadline)
                        .onTapGesture {
                            listsViewModel.addComent(comment, to: item, from: list)
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
        .padding(.vertical, 5)
    }
}

//struct ItemCommentView_Previews: PreviewProvider {
//    static let products = ProductListViewModel().products
//
//    static var previews: some View {
//        NavigationView{
//            ItemCommentView(item: ItemModel(product: products[0]), category: 0)
//                .previewLayout(.sizeThatFits)
//        } .environmentObject(ListsViewModel())
//    }
//}
