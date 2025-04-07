import UIKit
import TDCore

final class MainTabBarCoordinator: Coordinator {
    // MARK: - Properties
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable

    private lazy var tabBarController: MainTabBarController = {
        MainTabBarController(coordinator: self)
    }()

    // MARK: - Initializer
    init(
        navigationController: UINavigationController,
        injector: DependencyResolvable
    ) {
        self.navigationController = navigationController
        self.injector = injector
    }

    func start() {
        let items: [UINavigationController] = MainTabbarItem.allCases.map { createNavigationController(for: $0) }
        configureTabBarController(with: items)
    }

    // MARK: - Configuration
    private func configureTabBarController(with viewControllers: [UIViewController]) {
        navigationController.setNavigationBarHidden(true, animated: false)
        tabBarController.setViewControllers(viewControllers, animated: false)
        navigationController.viewControllers = [tabBarController]
    }

    private func createNavigationController(for item: MainTabbarItem) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.tabBarItem = item.item
        configureCoordinator(for: item, navigationController: navigationController)
        return navigationController
    }

    private func configureCoordinator(for item: MainTabbarItem, navigationController: UINavigationController) {
        let coordinator: Coordinator

        switch item {
        case .home:
            coordinator = HomeCoordinator(navigationController: navigationController, injector: injector)
        case .timer:
            coordinator = TimerCoordinator(navigationController: navigationController, injector: injector)
        case .diary:
            coordinator = DiaryCoordinator(navigationController: navigationController, injector: injector)
        case .social:
            coordinator = SocialListCoordinator(navigationController: navigationController, injector: injector)
        case .mypage:
            coordinator = MyPageCoordinator(navigationController: navigationController, injector: injector)
        }

        addCoordinator(coordinator)
    }

    private func addCoordinator(_ coordinator: Coordinator) {
        coordinator.finishDelegate = self
        coordinator.start()
        childCoordinators.append(coordinator)
    }
}

// MARK: - CoordinatorFinishDelegate
extension MainTabBarCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === childCoordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}

extension MainTabBarCoordinator {
    func switchToHomeTab() {
        tabBarController.selectedIndex = MainTabbarItem.home.index
    }
}
