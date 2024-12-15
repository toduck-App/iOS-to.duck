import UIKit
import TDCore

final class TabBarCoordinator: Coordinator {
    // MARK: - Properties
    var navigationController: UINavigationController
    var childCoordinators: [any Coordinator] = []
    var finishDelegate: CoordinatorFinishDelegate?

    private lazy var tabBarController: MainTabBarController = {
        MainTabBarController(coordinator: self)
    }()

    // MARK: - Initializer
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let items: [UINavigationController] = TabbarItem.allCases.map { createNavigationController(for: $0) }
        configureTabBarController(with: items)
    }

    // MARK: - Configuration
    private func configureTabBarController(with viewControllers: [UIViewController]) {
        navigationController.setNavigationBarHidden(true, animated: false)
        tabBarController.setViewControllers(viewControllers, animated: false)
        navigationController.viewControllers = [tabBarController]
    }

    private func createNavigationController(for item: TabbarItem) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.tabBarItem = item.item
        configureCoordinator(for: item, navigationController: navigationController)
        return navigationController
    }

        switch item {
        case .home:
            let coordinator = HomeCoordinator(navigationController: navigationController)
            addCoordinator(coordinator: coordinator)
        case .timer:
            let coordinator = TimerCoordinator(navigationController: navigationController)
            addCoordinator(coordinator: coordinator)
        case .diary:
            let coordinator = DiaryCoordinator(navigationController: navigationController)
            addCoordinator(coordinator: coordinator)
        case .social:
            let coordinator = SocialListCoordinator(navigationController: navigationController)
            addCoordinator(coordinator: coordinator)
        case .mypage:
            let coordinator = MyPageCoordinator(navigationController: navigationController)
            addCoordinator(coordinator: coordinator)
        }
    }

    private func addCoordinator(_ coordinator: Coordinator) {
        coordinator.finishDelegate = self
        coordinator.start()
        childCoordinators.append(coordinator)
    }
}

// MARK: - CoordinatorFinishDelegate
extension TabBarCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: any Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === childCoordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}
