//
//  DropViewDelegate.swift
//  Superlista
//
//  Created by Marina De Pazzi on 11/05/21.
//

import Foundation
import SwiftUI

struct DropViewDelegate: DropDelegate {
    var item: ItemModel
    @Binding var items: [ItemModel]
    var currentItem: ItemModel?
    
    func performDrop(info: DropInfo) -> Bool {
        return true
    }
    
    func dropEntered(info: DropInfo) {
        let fromIndex = items.firstIndex{ item -> Bool in
            return item.id == currentItem?.id
        } ?? 0
        
        let toIndex = items.firstIndex{ item -> Bool in
            return item.id == self.item.id
        } ?? 0
        
        if fromIndex != toIndex {
            withAnimation {
                let fromItem = items[fromIndex]
                items[fromIndex] = items[toIndex]
                items[toIndex] = fromItem
            }
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}
