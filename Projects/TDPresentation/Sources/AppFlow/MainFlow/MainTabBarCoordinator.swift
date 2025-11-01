import UIKit
import TDDomain
import TDCore

public protocol DeepLinkRoutable: AnyObject {
    func route(to deepLink: DeepLinkType, dismissPresented: Bool)
}

final class MainTabBarCoordinator: Coordinator, DeepLinkRoutable {
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
        let items: [UINavigationController] = MainTabbarItem.allCases.map { createNavigationController(for: $0) }
        configureTabBarController(with: items)
        presentEventSheet()
    }
    
    // MARK: - Configuration
    private func configureTabBarController(with viewControllers: [UIViewController]) {
        navigationController.setNavigationBarHidden(true, animated: false)
        tabBarController.setViewControllers(viewControllers, animated: false)
        navigationController.viewControllers = [tabBarController]
        configurePushNotification()
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
    
    
    func route(to deepLink: DeepLinkType, dismissPresented: Bool = true) {
        if dismissPresented {
            navigationController.presentedViewController?.dismiss(animated: false)
        }
        handleDeepLink(deepLink)
    }
    
    // MARK: - Deep Linking
    func handleDeepLink(_ link: DeepLinkType) {
        switch link {
        case .home:
            selectTab(.home)
            navigationController.popToRootViewController(animated: false)
            
        case .todo:
            selectTab(.home)
            (childCoordinators.first { $0 is HomeCoordinator } as? HomeCoordinator)?
                .startForTodo()
            
        case .notification:
            selectTab(.home)
            (childCoordinators.first { $0 is HomeCoordinator } as? HomeCoordinator)?
                .didTapAlarmButton()
            
        case .diary:
            handleDiaryDeepLink(link)
            
        case .profile, .post, .createPost:
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
            
        case .post(let postId, let commentIdString):
            if let postId = Int(postId),
               let commentIdString, let commentId = Int(commentIdString) {
                socialCoordinator.didTapPost(postId: postId, commentId: commentId)
            }
            
        case .createPost:
            socialCoordinator.didTapCreateButton()
            
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
    
    private func presentEventSheet() {
        guard TDTokenManager.shared.shouldShowEventSheetToday else { return }
        let eventCoordinator = EventSheetCoordinator(navigationController: navigationController, injector: injector)
        eventCoordinator.deepLinkRouter = self
        childCoordinators.append(eventCoordinator)
        eventCoordinator.finishDelegate = self
        eventCoordinator.start()
    }
}

// MARK: - CoordinatorFinishDelegate
extension MainTabBarCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
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

extension MainTabBarCoordinator {
    // MARK: - 푸시 알림 권한 요청
    
    private func configurePushNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                
                if UserDefaults.standard.object(forKey: UserDefaultsConstant.pushEnabledKey) == nil {
                    UserDefaults.standard.set(true, forKey: UserDefaultsConstant.pushEnabledKey)
                }
            } else {
                print("❌ 푸시 알림 권한 거부 또는 오류: \(error?.localizedDescription ?? "unknown error")")
                UserDefaults.standard.set(false, forKey: "PushEnabled")
            }
        }
    }
}
