import UIKit
import WebKit

final class BrowserViewController: UIViewController {
    
    private var contentView: WKWebView!
    private var loadingView: LoadingView?
    private let resourceLink: String
    private var isInitialLoad = true
    
    init(link: String) {
        self.resourceLink = link
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupContentView()
        showLoading()
        loadResource()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    private func setupContentView() {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .nonPersistent()
        
        contentView = WKWebView(frame: .zero, configuration: config)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.navigationDelegate = self
        contentView.scrollView.contentInsetAdjustmentBehavior = .never
        contentView.allowsBackForwardNavigationGestures = true
        contentView.backgroundColor = .black
        contentView.isOpaque = false
        
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func showLoading() {
        loadingView = LoadingView(frame: view.bounds)
        loadingView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let loadingView = loadingView {
            view.addSubview(loadingView)
        }
    }
    
    private func hideLoading() {
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
    
    private func loadResource() {
        guard let destination = URL(string: resourceLink) else { return }
        var request = URLRequest(url: destination)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        contentView.load(request)
    }
}

extension BrowserViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if isInitialLoad {
            hideLoading()
            isInitialLoad = false
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if isInitialLoad {
            hideLoading()
            isInitialLoad = false
        }
    }
}
