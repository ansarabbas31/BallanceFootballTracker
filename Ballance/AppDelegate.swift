import UIKit
import StoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let storageService = StorageService.shared
    private var shouldRequestReview = false
    private let reviewShownKey = "review_already_shown"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let alreadyShown = UserDefaults.standard.bool(forKey: reviewShownKey)
        shouldRequestReview = !alreadyShown && storageService.getToken() != nil
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RootViewController()
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if shouldRequestReview {
            shouldRequestReview = false
            UserDefaults.standard.set(true, forKey: reviewShownKey)
            requestAppReview()
        }
    }

    private func requestAppReview() {
        guard let scene = window?.windowScene else { return }
        SKStoreReviewController.requestReview(in: scene)
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if let rootVC = window?.rootViewController {
            if rootVC is BrowserViewController || 
               (rootVC as? UINavigationController)?.visibleViewController is BrowserViewController {
                return .all
            }
        }
        return .portrait
    }
}
