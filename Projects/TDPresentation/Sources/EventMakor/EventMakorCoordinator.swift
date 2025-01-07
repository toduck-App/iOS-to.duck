import UIKit
import TDCore

final class EventMakorCoordinator: Coordinator {
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

    func start(mode: ScheduleAndRoutineViewController.Mode) {
        let viewModel = EventMakorViewModel()
        let eventMakorViewController = EventMakorViewController(mode: mode, viewModel: viewModel)
        eventMakorViewController.coordinator = self
        navigationController.pushTDViewController(eventMakorViewController, animated: true)
    }
    
    func start() { }
}

// MARK: - Coordinator Finish Delegate
extension EventMakorCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}
