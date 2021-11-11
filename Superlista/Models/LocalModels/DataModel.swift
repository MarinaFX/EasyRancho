import Foundation

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

func loadCategoryKeys() -> [String] {
    return ProductListViewModel().products.map { $0.category }.unique.sorted()
}

func saveUserData<T: Encodable>(data: [T], to key: String) {
    if let encodedData = try? JSONEncoder().encode(data) {
        UserDefaults.standard.set(encodedData, forKey: key)
    }
}
