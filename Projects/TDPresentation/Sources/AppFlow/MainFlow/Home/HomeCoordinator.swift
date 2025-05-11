import UIKit
import TDDomain
import TDCore

protocol TodoViewControllerDelegate: AnyObject {
    func didTapEventMakor(mode: TodoCreatorViewController.Mode, selectedDate: Date?, preEvent: (any TodoItem)?, delegate: TodoCreatorCoordinatorDelegate?)
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
    
    func startForTodo() {
        let homeViewController = HomeViewController()
        homeViewController.coordinator = self
        homeViewController.segmentedControl.setSelectedIndex(1, animated: true)
        navigationController.pushViewController(homeViewController, animated: false)
    }
}

// MARK: - Coordinator Finish Delegate
extension HomeCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}

// MARK: - EventMakorDelegate
extension HomeCoordinator: TodoViewControllerDelegate {
    func didTapEventMakor(
        mode: TodoCreatorViewController.Mode,
        selectedDate: Date?,
        preEvent: (any TodoItem)?,
        delegate: TodoCreatorCoordinatorDelegate?
    ) {
        guard let selectedDate else { return }
        let eventMakorCoordinator = TodoCreatorCoordinator(
            navigationController: navigationController,
            injector: injector,
            selectedDate: selectedDate
        )
        eventMakorCoordinator.finishDelegate = self
        eventMakorCoordinator.delegate = delegate
        childCoordinators.append(eventMakorCoordinator)
        eventMakorCoordinator.start(mode: mode, preEvent: preEvent)
    }
}

// MARK: - Navigation Delegate
extension HomeCoordinator: NavigationDelegate {
    func didTapAlarmButton() {
        let notificationCoordinator = NotificationCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        notificationCoordinator.finishDelegate = self
        childCoordinators.append(notificationCoordinator)
        notificationCoordinator.start()
    }
    
    func didTapCalendarButton() {
        let toduckCalendarCoordinator = ToduckCalendarCoordinator(navigationController: navigationController, injector: injector)
        toduckCalendarCoordinator.finishDelegate = self
        childCoordinators.append(toduckCalendarCoordinator)
        toduckCalendarCoordinator.start()
    }
}
