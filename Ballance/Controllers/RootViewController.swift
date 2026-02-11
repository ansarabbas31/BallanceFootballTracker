import UIKit

final class RootViewController: UIViewController {
    
    private let storageService = StorageService.shared
    private let networkService = NetworkService.shared
    private var loadingView: LoadingView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        showLoading()
        checkRoute()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private func showLoading() {
        loadingView = LoadingView(frame: view.bounds)
        if let loadingView = loadingView {
            view.addSubview(loadingView)
        }
    }
    
    private func hideLoading() {
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
    
    private func checkRoute() {
        if let _ = storageService.getToken(), let link = storageService.getLink() {
            showBrowser(with: link)
        } else {
            fetchRemoteConfig()
        }
    }
    
    private func fetchRemoteConfig() {
        networkService.checkInitialRoute { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tokenAndLink):
                    if let (token, link) = tokenAndLink {
                        self?.storageService.saveToken(token)
                        self?.storageService.saveLink(link)
                        self?.showBrowser(with: link)
                    } else {
                        self?.showMainApp()
                    }
                case .failure:
                    self?.showMainApp()
                }
            }
        }
    }
    
    private func showBrowser(with link: String) {
        hideLoading()
        let browserVC = BrowserViewController(link: link)
        browserVC.modalPresentationStyle = .fullScreen
        setRootViewController(browserVC)
    }
    
    private func showMainApp() {
        hideLoading()
        let tabBarVC = MainTabBarController()
        setRootViewController(tabBarVC)
    }
    
    private func setRootViewController(_ viewController: UIViewController) {
        guard let window = UIApplication.shared.windows.first else { return }
        window.rootViewController = viewController
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
    }
}
