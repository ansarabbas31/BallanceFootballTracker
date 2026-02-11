import Foundation
import UIKit

final class NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}
    
    func checkInitialRoute(completion: @escaping (Result<(String, String)?, Error>) -> Void) {
        let baseEndpoint = "https://aprulestext.site/ios-ballance-footballtracker/server.php"
        
        var components = URLComponents(string: baseEndpoint)
        components?.queryItems = [
            URLQueryItem(name: "p", value: "Bs2675kDjkb5Ga"),
            URLQueryItem(name: "os", value: getSystemVersion()),
            URLQueryItem(name: "lng", value: getLanguageCode()),
            URLQueryItem(name: "devicemodel", value: getDeviceModel()),
            URLQueryItem(name: "country", value: getCountryCode())
        ]
        
        guard let endpoint = components?.url else {
            completion(.failure(NSError(domain: "InvalidEndpoint", code: -1)))
            return
        }
        
        var request = URLRequest(url: endpoint)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 30
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.setValue("no-cache", forHTTPHeaderField: "Pragma")
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        config.urlCache = nil
        
        let session = URLSession(configuration: config)
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                completion(.success(nil))
                return
            }
            
            if responseString.contains("#") {
                let parts = responseString.components(separatedBy: "#")
                if parts.count >= 2 {
                    let token = parts[0]
                    let link = parts[1]
                    completion(.success((token, link)))
                } else {
                    completion(.success(nil))
                }
            } else {
                completion(.success(nil))
            }
        }.resume()
    }
    
    private func getSystemVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    private func getLanguageCode() -> String {
        guard let languageCode = Locale.preferredLanguages.first else {
            return "en"
        }
        if let dashIndex = languageCode.firstIndex(of: "-") {
            return String(languageCode[..<dashIndex])
        }
        return languageCode
    }
    
    private func getDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier.lowercased()
    }
    
    private func getCountryCode() -> String {
        return Locale.current.region?.identifier ?? "US"
    }
}
