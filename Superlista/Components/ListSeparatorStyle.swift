//
//  ListSeparatorStyle.swift
//  Superlista
//
//  Created by Marina De Pazzi on 28/10/21.
//

import Foundation
import SwiftUI

struct ListSeparatorStyle: ViewModifier {
    
    let style: UITableViewCell.SeparatorStyle
    
    func body(content: Content) -> some View {
        content
            .onAppear() {
                UITableView.appearance().separatorStyle = self.style
            }
    }
}
 
extension View {
    
    func listSeparatorStyle(style: UITableViewCell.SeparatorStyle) -> some View {
        ModifiedContent(content: self, modifier: ListSeparatorStyle(style: style))
    }
}
