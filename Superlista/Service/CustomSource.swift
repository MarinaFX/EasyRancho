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
        return url
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        let image = UIImage(named: "AppIcon")
        
        metadata.title = "Lista: \(listName) \nCriada por: \(ownerName)"
        
        metadata.imageProvider = NSItemProvider(object: image!)
        return metadata
    }
}
