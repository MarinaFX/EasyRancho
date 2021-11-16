import UIKit
import LinkPresentation

class CustomSource: NSObject, UIActivityItemSource {
    let url: URL
    let listID: String
    let option: String
    let listName: String
    let ownerName: String
    
    init(listID: String, option: String, listName: String, ownerName: String) {
        self.listID = listID
        self.option = option
        self.listName = listName
        self.ownerName = ownerName
        self.url = URL(string: "easyrancho://" + listID + "$" + option) ?? URL(string: "apple.com")!
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return url
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        let optionText = option == "1" ? NSLocalizedString("addCollabListText", comment: "addCollabListText") : NSLocalizedString("shareListText", comment: "shareListText");
        
        let text = "\(optionText) '\(listName)' \(NSLocalizedString("easyRanchoText", comment: "easyRanchoText"))\n\n\(NSLocalizedString("acesse", comment: "acesse"))"
        
        return "\(text): \(url)"
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        let image = UIImage(named: "AppIcon")
        
        let list = NSLocalizedString("Lista", comment: "Lista: ")
        let by = NSLocalizedString("Criada por", comment: "Criada por: ")
        
        metadata.title = "\(list): \(listName)\n\(by): \(ownerName)"
        
        if let img = image {
            metadata.imageProvider = NSItemProvider(object: img)
        }
        
        return metadata
    }
}
