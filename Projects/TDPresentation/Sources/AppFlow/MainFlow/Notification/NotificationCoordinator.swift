import TDCore
import TDDomain
import UIKit

public final class NotificationCoordinator: Coordinator {
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public var finishDelegate: CoordinatorFinishDelegate?
    public var injector: DependencyResolvable
    private var splashViewController: SplashViewController?
    
    public init(
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
}
