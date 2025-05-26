import TDCore
import TDDomain
import UIKit

protocol RoutineShareCoordinatorDelegate: AnyObject {
    func didTapSelectCategory()
}

final class RoutineShareCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [any Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable
    let routine: Routine

    init(
        navigationController: UINavigationController,
        injector: DependencyResolvable,
        routine: Routine
    ) {
        self.navigationController = navigationController
        self.injector = injector
        self.routine = routine
    }

    func start() {
        let shareRoutineUseCase = injector.resolve(ShareRoutineUseCase.self)
        let viewModel = RoutineShareViewModel(
            routine: routine,
            shareRoutineUseCase: shareRoutineUseCase
        )
        let controller = RoutineShareViewController(viewModel: viewModel)
        controller.coordinator = self
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        navigationController.present(controller, animated: true)
    }
}

extension RoutineShareCoordinator: RoutineShareCoordinatorDelegate, CoordinatorFinishDelegate, SheetColorDelegate {
    func didSaveCategory() {
        start()
    }

    func didFinish(childCoordinator: any Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }

    func didTapSelectCategory() {
        if let viewController = navigationController.presentedViewController {
            viewController.dismiss(animated: true)
        }
        let sheetColorCoordinator = SheetColorCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        sheetColorCoordinator.finishDelegate = self
        sheetColorCoordinator.delegate = self
        childCoordinators.append(sheetColorCoordinator)
        sheetColorCoordinator.start()
    }
    
    func showErrorAlert(message: String) {
        if let viewController = navigationController.presentedViewController {
            viewController.dismiss(animated: true)
        }
        guard let currentViewController = navigationController.topViewController as? ErrorAlertDisplayable else {
            return
        }
        currentViewController.showErrorAlert(errorMessage: message)
        didFinish(childCoordinator: self)
    }
}
