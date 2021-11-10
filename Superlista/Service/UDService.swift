import Foundation

class UDService {
    
    // MARK: - Lists
    private let UDListsKey: String = "lists"

    func getUDLists() -> [ListModel] {
        if let listData = UserDefaults.standard.data(forKey: UDListsKey),
           let savedLists = try? JSONDecoder().decode([ListModel].self, from: listData) {
            
            return savedLists
        }
        return []
    }
    
    func saveListsOnUD(lists: [ListModel]) {
        if let encodedListData = try? JSONEncoder().encode(lists) {
            UserDefaults.standard.set(encodedListData, forKey: UDListsKey)
        }
    }
    
    // MARK: - Users
    private let UDUserKey: String = "users"
    
    func getUDUser() -> UserModel? {
        if let userData = UserDefaults.standard.data(forKey: UDUserKey),
           let savedUser = try? JSONDecoder().decode(UserModel.self, from: userData) {

            return savedUser
        }
        return nil
    }
    
    func saveUserOnUD(user: UserModel?) {
        if let user = user,
           let encodedUserData = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encodedUserData, forKey: UDUserKey)
        }
    }
}