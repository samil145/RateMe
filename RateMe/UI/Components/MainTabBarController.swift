import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
    // MARK: - Setup
    private func setupViewControllers() {
        let discoverVC = DiscoverViewController()
        discoverVC.tabBarItem = UITabBarItem(
            title: "Discover",
            image: UIImage(systemName: "person.2.fill"),
            selectedImage: UIImage(systemName: "person.2.fill")
        )
        
        let analyticsVC = AnalyticsViewController()
        analyticsVC.tabBarItem = UITabBarItem(
            title: "Analytics",
            image: UIImage(systemName: "chart.bar.fill"),
            selectedImage: UIImage(systemName: "chart.bar.fill")
        )
        
        let notificationsVC = NotificationsViewController()
        notificationsVC.tabBarItem = UITabBarItem(
            title: "Notifications",
            image: UIImage(systemName: "bell.fill"),
            selectedImage: UIImage(systemName: "bell.fill")
        )
        
        let profileVC = ProfileViewController(profile: Profile.mockProfiles[0])
        profileVC.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.fill"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        viewControllers = [
            UINavigationController(rootViewController: discoverVC),
            UINavigationController(rootViewController: analyticsVC),
            UINavigationController(rootViewController: notificationsVC),
            UINavigationController(rootViewController: profileVC)
        ]
    }
} 