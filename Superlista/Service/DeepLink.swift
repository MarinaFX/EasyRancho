import Foundation

struct DeepLink {
    var id: String
    var listID: String?
    var option: String?
    
    init(id: String) {
        self.id = id
        let ids = id.components(separatedBy: "$")
        listID = ids[0]
        option = ids[1]
    }
}
