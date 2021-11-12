//
//  ProductCounter.swift
//  Superlista
//
//  Created by Thaís Fernandes on 11/11/21.
//

import SwiftUI

struct QuantityCounter: View {
    var item: ItemModel
    @Binding var list: ListModel?
    
    var body: some View {
        HStack {
            ZStack {
                Image(systemName: "minus")
                    .resizable()
                    .frame(width: 17, height: ((item.quantity ?? 1) > 1) ? 2 : 1.5)
                    .foregroundColor(((item.quantity ?? 1) > 1) ? Color("Comment") : Color(UIColor.secondaryLabel))
            }
            .frame(width: 17, height: 17)
            .onTapGesture {
                if let list = list {
                    let newList = list.removeQuantity(of: item)
                    self.list = newList
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
            
            Image(systemName: "plus")
                .resizable()
                .frame(width: 17, height: 17)
                .foregroundColor(Color("Comment"))
                .onTapGesture {
                    if let list = list {
                        let newList = list.addQuantity(of: item)
                        self.list = newList
                    }
                }
                .accessibilityAddTraits(AccessibilityTraits.isButton)
                .accessibilityRemoveTraits(AccessibilityTraits.isImage)
                .accessibilityLabel(Text("Add"))
                .accessibility(hint: Text("AddOneItem"))
        }
    }
}

