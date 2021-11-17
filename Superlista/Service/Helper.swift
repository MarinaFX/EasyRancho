import Foundation
import CloudKit
import SwiftUI

//MARK: - Enums
// MARK: - UsersList Enum
enum UsersList: String {
    case MyLists, SharedWithMe
}

//MARK: - Functions
// MARK: - ImageToCKAsset
func ImageToCKAsset(uiImage: UIImage?) -> CKAsset? {
    guard let uiImage = uiImage else { return nil }
    
    guard let data = uiImage.jpegData(compressionQuality: 0.5) else { return nil }
    
    guard let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat") else { return nil }
    
    do {
        try data.write(to: url)
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
func shareSheetList(listID: String, option: String, listName: String, ownerName: String) {
    let activityVC = UIActivityViewController(activityItems: [CustomSourceList(listID: listID, option: option, listName: listName, ownerName: ownerName)], applicationActivities: nil)
    let keyWindow = UIApplication.shared.windows.first(where: \.isKeyWindow)
    var topController = keyWindow?.rootViewController
    
    // get topmost view controller to present alert
    while let presentedViewController = topController?.presentedViewController {
        topController = presentedViewController
    }
    
    topController?.present(activityVC, animated: true, completion: nil)
}

// MARK: - ShareSheetAppStore
func shareSheetAppStore(){
    let activityVC = UIActivityViewController(activityItems: [CustomSourceAppStore()], applicationActivities: nil)
    
    let keyWindow = UIApplication.shared.windows.first(where: \.isKeyWindow)
    
    var topController = keyWindow?.rootViewController
    
    while let presentedViewController = topController?.presentedViewController {
        topController = presentedViewController
    }
    topController?.present(activityVC, animated: true, completion: nil)
    
    activityVC.isModalInPresentation = true
}

// MARK: - Get Color Categories
func getColor(category: String) -> Color {
    switch category {
    case "Bazar", "Haushaltsartikel", "Home":
        return Color("Bazar")
    case "Bebidas", "Getränke", "Drinks":
        return Color("Bebidas")
        case "Bomboniere":
        return Color("Bomboniere")
    case "Carnes", "Meats", "Fleisch":
        return Color("Carnes")
    case "Compotas e doces", "Konfitüren und Gelees", "Jams and sweets":
        return Color("Compotasedoces")
        case "Congelados", "Frozen", "Tiefkühlkost":
        return Color("Congelados")
    case "Enlatados, conservas e óleos", "Lebensmittelkonserven und Öle", "Canned, pickled and oils":
        return Color("Enlatadosconservaseoleos")
    case "Especiais", "Specials", "Sonderposten":
        return Color("Especiais")
    case "Fiambreria e laticínios", "Schinken und Molkereiprodukte", "Hams and dairy products":
        return Color("Fiambreriaelaticinios")
    case "Grãos e farinhas", "Körner und Mehle", "Grains and flours":
        return Color("Graosefarinhas")
    case "Higiene e beleza", "Hygiene und Schönheit", "Beauty and hygiene":
        return Color("Higieneebeleza")
    case "Hortifruti", "Vegetables", "Obst und Gemüse":
        return Color("Hortifruti")
    case "Limpeza", "Cleaning", "Reinigung":
        return Color("Limpeza")
    case "Massas e biscoitos", "Nudeln und Kekse", "Pasta and cookies":
        return Color("Massasebiscoitos")
    case "Matinais", "Breakfast", "Morgen":
        return Color("Matinais")
    case "Molhos", "Sauces", "Saucen":
        return Color("Molhos")
    case "Padaria", "Bäckerei", "Bakery":
        return Color("Padaria")
    case "PetShop", "Zoohandlung":
        return Color("PetShop")
    case "Sobremesas", "Desserts":
        return Color("Sobremesas")
    case "Temperos", "Gewürze", "Seasonings":
        return Color("Temperos")
    case "Outros", "Others", "Andere":
        return Color("Outros")
    default:
        return Color("Outros")
    }
}

// MARK: - Curtom usernames
func getNickname() -> String{
    if let colors = UserArrays().colorsArray.randomElement(), let animals = UserArrays().animalsArray.randomElement() {
        return "\(colors) \(animals)"
    }
    return "User"
}

// MARK: - Difference between arrays
extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}

func getRandomUniqueID(blacklist existingIds: [Int]) -> Int {
    var newRandom: Int = random()

    while existingIds.contains(newRandom) {
        newRandom = random()
    }
    
    return newRandom
}

func random() -> Int {
    return Int.random(in: 1000..<9999)
}

//MARK: - Extensions
extension Array where Element: Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        return uniqueValues
    }
}

// MARK: - Get ForegroundColor for buttons
func getForegroundColor(list: ListModel?, networkMonitor: NetworkMonitor) -> Bool {
    if let sharedWith = list?.sharedWith {
        if (networkMonitor.status == .satisfied) || sharedWith.isEmpty {
            return true // verde
        } else {
            return false
        }
    }
    return true
}
