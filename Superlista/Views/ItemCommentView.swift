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
    @State var canComment: Bool = false
    @State var comentario: String = ""
    
    var item: ItemModel
    var list: ListModel
    
    var body: some View {
        ZStack {
            VStack (alignment: .leading, spacing: -1) {
                HStack {
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
                        //.font(.system(size: 15, weight: .semibold))
                    
                    Spacer()
                    
                    if !canComment{
                        Image(systemName: "text.bubble")
                            .resizable()
                            .frame(width: 22, height: 22)
                            .foregroundColor(purpleColor)
                            .onTapGesture {
                                canComment = true
                            }
                    }
                    
                }
                if canComment {
                    
                    HStack {
                        ZStack(alignment: .leading){
                            if ((comentario) == "") {
                                Text("Insira um comentário")
                                    .foregroundColor(Color(UIColor.secondaryLabel))
                                    .font(.system(size: 13))
                                    .padding(.leading, 30)
    
                            }
                            TextField("", text: $comentario)
                                .font(.system(size: 13))
                                .foregroundColor(Color(UIColor.secondaryLabel))
                                .padding(.leading, 28)
                        }
                        
                        Spacer()
                        
                        Text("OK")
                            .foregroundColor(Color.primary)
                            .font(.subheadline)
                            .onTapGesture {
                                listsViewModel.addComent(comentario, to: item, from: list)
                                canComment = false
                                
                            }
                    }
                }
                
                if !canComment{
                    Text(item.comment ?? "")
                        .font(.system(size: 13))
                        .foregroundColor(Color(UIColor.secondaryLabel))
                        .padding(.leading, 28)
                }
            }
        }
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
