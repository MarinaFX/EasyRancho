//
//  DropViewDelegate.swift
//  Superlista
//
//  Created by Marina De Pazzi on 11/05/21.
//

import Foundation
import SwiftUI

struct DropViewDelegate: DropDelegate {
    var listsViewModel: ListsViewModel
    
    var list: ListModel
    
    func performDrop(info: DropInfo) -> Bool {
        return true
    }
    
    func dropEntered(info: DropInfo) {
        let fromIndex = listsViewModel.list.firstIndex{ list -> Bool in
            return list.id == listsViewModel.currentList?.id
        } ?? 0
        
        let toIndex = listsViewModel.list.firstIndex{ list -> Bool in
            return list.id == self.list.id
        } ?? 0
        
        if fromIndex != toIndex {
            withAnimation {
                let fromList = listsViewModel.list[fromIndex]
                listsViewModel.list[fromIndex] = listsViewModel.list[toIndex]
                listsViewModel.list[toIndex] = fromList
            }
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}
