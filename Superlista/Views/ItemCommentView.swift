//
//  ItemCommentView.swift
//  Superlista
//
//  Created by Gabriela Zorzo on 12/05/21.
//

import SwiftUI

struct ItemCommentView: View {
    let integration = DataModelIntegration.integration

    let purpleColor = Color("HeaderColor")
    @State var isCommenting: Bool = false
    @State var comment: String = ""
    
    var item: ItemModel
    var list: ListModel
    
    var body: some View {
        ZStack{
            Color("background")
                .ignoresSafeArea()
            
            VStack (alignment: .leading, spacing: 0) {
                
                HStack(alignment: .center) {
                    
                    Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                        .foregroundColor(item.isCompleted ? Color(UIColor.secondaryLabel) : Color.primary)
                        .font(.system(size: 18, weight: .light))
                        .onTapGesture {
                            integration.toggleCompletion(of: item, from: list)
                        }
                    
                    Text(item.product.name)
                        .strikethrough(item.isCompleted)
                        .foregroundColor(item.isCompleted ? Color(UIColor.secondaryLabel) : Color.primary)
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
                                integration.addComent(comment, to: item, from: list)
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
            .background(Color("background"))
            .onAppear {
                self.comment = item.comment ?? ""
            }
            .padding(.vertical, 5)
        }
    }
}
