//
//  DeepLink.swift
//  Superlista
//
//  Created by Gabriela Zorzo on 06/10/21.
//

import Foundation

struct DeepLink {
    var id: String
    var listID: String?
    var ownerID: String?
    
    init(id: String) {
        self.id = id
        let ids = id.components(separatedBy: "$")
        ownerID = ids[0]
        listID = ids[1]
    }
}
