import Foundation
import SwiftUI

struct ListDropViewDelegate: DropDelegate {
    var dataService: DataService
    
    var list: ListModel
    
    func performDrop(info: DropInfo) -> Bool {
        return true
    }
    
    func dropEntered(info: DropInfo) {
        let fromIndex = dataService.lists.firstIndex{ list -> Bool in
            return list.id == dataService.currentList?.id
        } ?? 0
        
        let toIndex = dataService.lists.firstIndex{ list -> Bool in
            return list.id == self.list.id
        } ?? 0
        
        if fromIndex != toIndex {
            withAnimation {
                let fromList = dataService.lists[fromIndex]
                dataService.lists[fromIndex] = dataService.lists[toIndex]
                dataService.lists[toIndex] = fromList
            }
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}
