import TDDesign
import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    weak var coordinator: MainTabBarCoordinator?
    
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
        tabBar.backgroundColor = TDColor.baseWhite
        tabBar.tintColor = TDColor.Primary.primary400
        tabBar.unselectedItemTintColor = TDColor.Neutral.neutral600
        tabBar.isTranslucent = false
    }
}
