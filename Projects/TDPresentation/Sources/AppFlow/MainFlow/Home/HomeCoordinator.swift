import UIKit
import TDDomain
import TDCore

protocol TodoViewControllerDelegate: AnyObject {
    func didTapTodoMakor(mode: TDTodoMode, selectedDate: Date?, preTodo: (any TodoItem)?, delegate: TodoCreatorCoordinatorDelegate?)
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
        if let homeVC = navigationController.viewControllers
            .first(where: { $0 is HomeViewController }) as? HomeViewController {
            homeVC.segmentedControl.setSelectedIndex(1, animated: true)
            navigationController.popToViewController(homeVC, animated: false)
        } else {
            let homeVC = HomeViewController()
            homeVC.coordinator = self
            homeVC.segmentedControl.setSelectedIndex(1, animated: true)
            navigationController.pushViewController(homeVC, animated: false)
        }
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
    func didTapTodoMakor(
        mode: TDTodoMode,
        selectedDate: Date?,
        preTodo: (any TodoItem)?,
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
        eventMakorCoordinator.start(mode: mode, preEvent: preTodo)
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
