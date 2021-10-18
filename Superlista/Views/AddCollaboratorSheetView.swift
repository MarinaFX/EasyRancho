//
//  AddCollaboratorSheetView.swift
//  Superlista
//
//  Created by Marina De Pazzi on 18/10/21.
//

import SwiftUI

struct AddCollaboratorSheetView: View {
    @Binding var showCollabSheetView: Bool
    
    var body: some View {
        Text("Marina!")
    }
}

struct AddColaboratorSheetView_Previews: PreviewProvider {
    static var previews: some View {
        AddCollaboratorSheetView(showCollabSheetView: .constant(false))
    }
}
