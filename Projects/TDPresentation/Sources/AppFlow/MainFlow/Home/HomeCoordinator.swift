import UIKit
import TDDomain
import TDCore

protocol TodoViewControllerDelegate: AnyObject {
    func didTapEventMakor(mode: EventMakorViewController.Mode, selectedDate: Date?, preEvent: (any Eventable)?, delegate: EventMakorCoordinatorDelegate?)
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

// MARK: - EventMakorDelegate
extension HomeCoordinator: TodoViewControllerDelegate {
    func didTapEventMakor(
        mode: EventMakorViewController.Mode,
        selectedDate: Date?,
        preEvent: (any Eventable)?,
        delegate: EventMakorCoordinatorDelegate?
    ) {
        guard let selectedDate else { return }
        let eventMakorCoordinator = EventMakorCoordinator(
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
        // TODO: 알람 페이지로 이동
        TDLogger.debug("알람 페이지로 이동")
    }
    
    func didTapCalendarButton() {
        let toduckCalendarCoordinator = ToduckCalendarCoordinator(navigationController: navigationController, injector: injector)
        toduckCalendarCoordinator.finishDelegate = self
        childCoordinators.append(toduckCalendarCoordinator)
        toduckCalendarCoordinator.start()
    }
}
