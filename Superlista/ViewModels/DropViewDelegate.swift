import Foundation
import SwiftUI

struct ListDropViewDelegate: DropDelegate {
    var listsViewModel: DataService
    
    var list: ListModel
    
    func performDrop(info: DropInfo) -> Bool {
        return true
    }
    
    func dropEntered(info: DropInfo) {
        let fromIndex = listsViewModel.lists.firstIndex{ list -> Bool in
            return list.id == listsViewModel.currentList?.id
        } ?? 0
        
        let toIndex = listsViewModel.lists.firstIndex{ list -> Bool in
            return list.id == self.list.id
        } ?? 0
        
        if fromIndex != toIndex {
            withAnimation {
                let fromList = listsViewModel.lists[fromIndex]
                listsViewModel.lists[fromIndex] = listsViewModel.lists[toIndex]
                listsViewModel.lists[toIndex] = fromList
            }
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}
