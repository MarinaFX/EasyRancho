import Foundation
import CloudKit
import SwiftUI

// MARK: - ImageToCKAsset
func ImageToCKAsset(uiImage: UIImage?) -> CKAsset? {
    if uiImage == nil { return nil }
    let data = uiImage!.jpegData(compressionQuality: 0.5); // UIImage -> NSData, see also UIImageJPEGRepresentation
    let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat")!
    do {
        try data?.write(to: url) //data!.writeToURL(url, options: [])
    } catch let e as NSError {
        print("Error! \(e)");
        return nil
    }
    return CKAsset(fileURL: url)
}

// MARK: - CKAssetToImage
func CKAssetToImage(ckImage: CKAsset?) -> Image? {
    guard let image: UIImage = CKAssetToUIImage(ckImage: ckImage) else {
        return nil
    }
    return Image(uiImage: image)
}

// MARK: - CKAssetToUIImage
func CKAssetToUIImage(ckImage: CKAsset?) -> UIImage? {
    if ckImage == nil {
        return nil
    }
    guard
        let photo = ckImage,
        let fileURL = photo.fileURL //verificar url se voltar a deitar a foto
    else {
        return nil
    }

    let imageData: Data
    do {
        imageData = try Data(contentsOf: fileURL)
    } catch {
        return nil
    }

    guard let image: UIImage = UIImage(data: imageData) else {
        return nil
    }
    return image //UIImage
}

// MARK: - ShareSheet
func shareSheet(listID: String, option: String, listName: String, ownerName: String) {
    let activityVC = UIActivityViewController(activityItems: [CustomSource(listID: listID, option: option, listName: listName, ownerName: ownerName)], applicationActivities: nil)
    let keyWindow = UIApplication.shared.windows.first(where: \.isKeyWindow)
    var topController = keyWindow?.rootViewController
    
    // get topmost view controller to present alert
    while let presentedViewController = topController?.presentedViewController {
        topController = presentedViewController
    }
    
    topController?.present(activityVC, animated: true, completion: nil)
}

// MARK: - Get Color Categories
func getColor(category: String) -> Color {
    switch category{
    case NSLocalizedString("Bazar", comment: "Bazar"):
        return Color("Bazar")
    case NSLocalizedString("Bebidas", comment: "Bebidas"):
        return Color("Bebidas")
    case NSLocalizedString("Bomboniere", comment: "Bomboniere"):
        return Color("Bomboniere")
    case NSLocalizedString("Carnes", comment: "Carnes"):
        return Color("Carnes")
    case NSLocalizedString("Compotasedoces", comment: "Compotas e doces"):
        return Color("Compotasedoces")
    case NSLocalizedString("Congelados", comment: "Congelados"):
        return Color("Congelados")
    case NSLocalizedString("Enlatadosconservaseoleos", comment: "Enlatados, conservas e oleos"):
        return Color("Enlatadosconservaseoleos")
    case NSLocalizedString("Especiais", comment: "Especiais"):
        return Color("Especiais")
    case NSLocalizedString("Fiambreriaelaticinios", comment: "Fiambreria e laticinios"):
        return Color("Fiambreriaelaticinios")
    case NSLocalizedString("Graosefarinhas", comment: "Graos e farinhas"):
        return Color("Graosefarinhas")
    case NSLocalizedString("Higieneebeleza", comment: "Higiene e beleza"):
        return Color("Higieneebeleza")
    case NSLocalizedString("Hortifruti", comment: "Hortifruti"):
        return Color("Hortifruti")
    case NSLocalizedString("Limpeza", comment: "Limpeza"):
        return Color("Limpeza")
    case NSLocalizedString("Massasebiscoitos", comment: "Massas e biscoitos"):
        return Color("Massasebiscoitos")
    case NSLocalizedString("Matinais", comment: "Matinais"):
        return Color("Matinais")
    case NSLocalizedString("Molhos", comment: "Molhos"):
        return Color("Molhos")
    case NSLocalizedString("Padaria", comment: "Padaria"):
        return Color("Padaria")
    case NSLocalizedString("PetShop", comment: "PetShop"):
        return Color("PetShop")
    case NSLocalizedString("Sobremesas", comment: "Sobremesas"):
        return Color("Sobremesas")
    case NSLocalizedString("Temperos", comment: "Temperos"):
        return Color("Temperos")
    case NSLocalizedString("Outros", comment: "Outros"):
        return Color("Outros")
    default:
        return Color.black
    }
}

// MARK: - UsersList Enum
enum UsersList: String {
    case MyLists, SharedWithMe
}

// MARK: - Curtom usernames
func getNickname() -> String{
    if let colors = UserArrays().colorsArray.randomElement(), let animals = UserArrays().animalsArray.randomElement() {
        return "\(colors) \(animals)"
    }
    return "User"
}
