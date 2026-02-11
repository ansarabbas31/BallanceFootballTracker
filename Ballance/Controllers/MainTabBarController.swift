import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private func setupTabs() {
        let trackerVC = UINavigationController(rootViewController: TrackerViewController())
        trackerVC.tabBarItem = UITabBarItem(title: "Tracker", image: UIImage(systemName: "soccerball"), tag: 0)
        
        let simulatorVC = UINavigationController(rootViewController: SimulatorViewController())
        simulatorVC.tabBarItem = UITabBarItem(title: "Simulator", image: UIImage(systemName: "play.rectangle.fill"), tag: 1)
        
        let historyVC = UINavigationController(rootViewController: HistoryViewController())
        historyVC.tabBarItem = UITabBarItem(title: "History", image: UIImage(systemName: "clock.fill"), tag: 2)
        
        let settingsVC = UINavigationController(rootViewController: SettingsViewController())
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape.fill"), tag: 3)
        
        viewControllers = [trackerVC, simulatorVC, historyVC, settingsVC]
    }
    
    private func setupAppearance() {
        tabBar.tintColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
        tabBar.backgroundColor = UIColor.systemBackground
        
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
