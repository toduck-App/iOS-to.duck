import UIKit
import TDCore

protocol EventMakorDelegate: AnyObject {
    func didTapEventMakor()
}

final class HomeCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable

    init(
        navigationController: UINavigationController,
        injector: DependencyResolvable
    ) {
        self.navigationController = navigationController
        self.injector = injector
    }

    func start() {
        let homeViewController = HomeViewController()
        homeViewController.coordinator = self
        navigationController.pushViewController(homeViewController, animated: false)
    }
}

// MARK: - Coordinator Finish Delegate
extension HomeCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}

// MARK: - Navigation Delegate
extension HomeCoordinator: NavigationDelegate {
    func didTapCalendarButton() {
        let toduckCalendarCoordinator = ToduckCalendarCoordinator(navigationController: navigationController)
        toduckCalendarCoordinator.finishDelegate = self
        childCoordinators.append(toduckCalendarCoordinator)
        toduckCalendarCoordinator.start()
    }
}

extension HomeCoordinator: EventMakorDelegate {
    func didTapEventMakor() {
        let eventMakorCoordinator = EventMakorCoordinator(navigationController: navigationController, injector: injector)
        eventMakorCoordinator.finishDelegate = self
        childCoordinators.append(eventMakorCoordinator)
        eventMakorCoordinator.start()
    }
}
