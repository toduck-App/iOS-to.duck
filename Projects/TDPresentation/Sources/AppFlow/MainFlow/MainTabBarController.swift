import TDDesign
import UIKit

protocol MainTabBarControllerDelegate: AnyObject {
    func didReselectHomeTab()
}

final class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    private var lastSelectedIndex: Int = 0
    weak var coordinator: MainTabBarCoordinator?
    weak var tabDelegate: MainTabBarControllerDelegate?
    
    init(coordinator: MainTabBarCoordinator? = nil) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        view.backgroundColor = TDColor.baseWhite
        tabBar.backgroundColor = TDColor.baseWhite
        tabBar.tintColor = TDColor.Primary.primary400
        tabBar.unselectedItemTintColor = TDColor.Neutral.neutral600
        tabBar.isTranslucent = false
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if selectedIndex == MainTabbarItem.home.index,
           lastSelectedIndex == MainTabbarItem.home.index,
           let navigationController = viewController as? UINavigationController,
           navigationController.viewControllers.first is HomeViewController {
            tabDelegate?.didReselectHomeTab()
        }
        lastSelectedIndex = selectedIndex
    }
}
