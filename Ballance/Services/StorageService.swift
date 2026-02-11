import Foundation

final class StorageService {
    
    static let shared = StorageService()
    
    private let defaults = UserDefaults.standard
    private let tokenKey = "auth_token_key"
    private let linkKey = "resource_link_key"
    
    private init() {}
    
    func saveToken(_ token: String) {
        defaults.set(token, forKey: tokenKey)
    }
    
    func getToken() -> String? {
        return defaults.string(forKey: tokenKey)
    }
    
    func saveLink(_ link: String) {
        defaults.set(link, forKey: linkKey)
    }
    
    func getLink() -> String? {
        return defaults.string(forKey: linkKey)
    }
    
    func clearAll() {
        defaults.removeObject(forKey: tokenKey)
        defaults.removeObject(forKey: linkKey)
    }
}
