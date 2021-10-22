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
func shareSheet(listID: String, ownerID: String, option: String, listName: String, ownerName: String) {
    let activityVC = UIActivityViewController(activityItems: [CustomSource(listID: listID, ownerID: ownerID, option: option, listName: listName, ownerName: ownerName)], applicationActivities: nil)
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
    case "Bazar" :
        return Color("Bazar")
    case "Bebidas" :
        return Color("Bebidas")
    case "Bomboniere" :
        return Color("Bomboniere")
    case "Carnes" :
        return Color("Carnes")
    case "Compotas e doces" :
        return Color("Compotasedoces")
    case "Congelados" :
        return Color("Congelados")
    case "Enlatados, conservas e óleos" :
        return Color("Enlatadosconservaseoleos")
    case "Especiais" :
        return Color("Especiais")
    case "Fiambreria e laticínios" :
        return Color("Fiambreriaelaticinios")
    case "Grãos e farinhas" :
        return Color("Graosefarinhas")
    case "Higiene e beleza" :
        return Color("Higieneebeleza")
    case "Hortifruti" :
        return Color("Hortifruti")
    case "Limpeza" :
        return Color("Limpeza")
    case "Massas e biscoitos" :
        return Color("Massasebiscoitos")
    case "Matinais" :
        return Color("Matinais")
    case "Molhos" :
        return Color("Molhos")
    case "Padaria" :
        return Color("Padaria")
    case "PetShop" :
        return Color("PetShop")
    case "Sobremesas" :
        return Color("Sobremesas")
    case "Temperos" :
        return Color("Temperos")
    case "Outros" :
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
        return "\(colors)\(animals)"
    }
    return "User"
}
