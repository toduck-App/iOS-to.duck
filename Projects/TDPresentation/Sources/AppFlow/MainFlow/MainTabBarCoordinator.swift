import UIKit
import TDCore

final class MainTabBarCoordinator: Coordinator {
    // MARK: - Properties
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable
    
    private lazy var tabBarController: MainTabBarController = {
        let controller = MainTabBarController(coordinator: self)
        controller.tabDelegate = self
        return controller
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
        if !TDTokenManager.shared.isFirstLogin {
            TDTokenManager.shared.launchFirstLogin()
            let walkThroughCoordinator = CoachCoordinator(navigationController: navigationController, injector: injector)
            addCoordinator(walkThroughCoordinator)
            walkThroughCoordinator.start()
            return
        }
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
    
    // MARK: - Deep Linking
    func handleDeepLink(_ link: DeepLinkType) {
        switch link {
        case .home:
            selectTab(.home)
            navigationController.popToRootViewController(animated: false)
            
        case .todo:
            selectTab(.home)
            //            (childCoordinators.first { $0 is HomeCoordinator } as? HomeCoordinator)?
            //                .handleDeepLink(link)
            
        case .notification:
            selectTab(.home)
            //            (childCoordinators.first { $0 is HomeCoordinator } as? HomeCoordinator)?
            //                .showNotificationList()
            
        case .diary:
            handleDiaryDeepLink(link)
            
        case .profile, .post:
            handleSocialDeepLink(link)
        }
    }
    
    private func handleSocialDeepLink(_ link: DeepLinkType) {
        selectTab(.social)
        
        guard let socialCoordinator = childCoordinators.first(where: { $0 is SocialListCoordinator }) as? SocialListCoordinator else {
            return
        }
        
        socialCoordinator.navigationController.popToRootViewController(animated: false)
        
        switch link {
        case .profile(let userId):
            if let userId = Int(userId) {
                socialCoordinator.showProfile(userId: userId)
            }
            
            //        case .post(let postId, let commentId):
            //            socialCoordinator.showPostDetail(
            //                postId: postId,
            //                scrollToComment: commentId != nil
            //            )
            //
        default:
            break
        }
    }
    
    private func handleDiaryDeepLink(_ link: DeepLinkType) {
        selectTab(.diary)
        
        guard let diaryCoordinator = childCoordinators.first(where: { $0 is DiaryCoordinator }) as? DiaryCoordinator else {
            return
        }
        
        diaryCoordinator.navigationController.popToRootViewController(animated: false)
        diaryCoordinator.start()
    }
    
    private func selectTab(_ item: MainTabbarItem) {
        guard let index = MainTabbarItem.allCases.firstIndex(of: item) else { return }
        tabBarController.selectedIndex = index
    }
}

// MARK: - CoordinatorFinishDelegate
extension MainTabBarCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
        if childCoordinator is CoachCoordinator {
            let items: [UINavigationController] = MainTabbarItem.allCases.map { createNavigationController(for: $0) }
            configureTabBarController(with: items)
        }
    }
}

extension MainTabBarCoordinator {
    func switchToHomeTab() {
        tabBarController.selectedIndex = MainTabbarItem.home.index
    }
}

extension MainTabBarCoordinator: MainTabBarControllerDelegate {
    func didReselectHomeTab() {
        if let navigationController = tabBarController.viewControllers?[MainTabbarItem.home.index] as? UINavigationController,
           let homeViewController = navigationController.viewControllers.first as? HomeViewController {
            homeViewController.resetToToduck()
        }
    }
}
