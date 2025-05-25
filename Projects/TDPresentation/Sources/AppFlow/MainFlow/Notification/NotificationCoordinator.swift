import TDCore
import TDDomain
import UIKit

final class NotificationCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable
    private var splashViewController: SplashViewController?
    
    init(
        navigationController: UINavigationController,
        injector: DependencyResolvable
    ) {
        self.navigationController = navigationController
        self.injector = injector
    }
    
    public func start() {
        let fetchNotificationListUseCase = injector.resolve(FetchNotificationListUseCase.self)
        let readAllNotificationsUseCase = injector.resolve(ReadAllNotificationsUseCase.self)
        let notificationViewModel = NotificationViewModel(
            fetchNotificationListUseCase: fetchNotificationListUseCase,
            readAllNotificationsUseCase: readAllNotificationsUseCase
        )
        let notificationViewController = NotificationViewController(viewModel: notificationViewModel)
        notificationViewController.coordinator = self
        navigationController.pushTDViewController(notificationViewController, animated: true)
    }
    
    func didSelectNotification(_ notification: TDNotificationDetail) {
        guard let actionUrl = notification.actionUrl,
              let url = URL(string: actionUrl),
              let deepLink = DeepLinkType(url: url) else { return }
        
        

        switch deepLink {
        case .post(let postId, let commentId):
            let socialDetailCoordinator = SocialDetailCoordinator(
                navigationController: navigationController,
                injector: injector,
                postId: Int(postId) ?? 0,
                commentId: commentId.flatMap { Int($0) }
            )
            socialDetailCoordinator.finishDelegate = self
            childCoordinators.append(socialDetailCoordinator)
            socialDetailCoordinator.start()
            
        default:
            break
        }
    }
}

extension NotificationCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}
