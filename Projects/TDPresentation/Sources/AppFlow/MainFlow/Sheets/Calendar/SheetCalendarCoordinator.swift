import FittedSheets
import UIKit
import TDCore
import TDDomain

final class SheetCalendarCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable
    weak var delegate: SheetCalendarDelegate?

    init(
        navigationController: UINavigationController,
        injector: DependencyResolvable
    ) {
        self.navigationController = navigationController
        self.injector = injector
    }

    func start() {
        let sheetViewController = SheetCalendarViewController()
        sheetViewController.delegate = delegate
        sheetViewController.coordinator = self
        let sheetController = SheetViewController(
            controller: sheetViewController,
            sizes: [.fixed(550)],
            options: .init(
                pullBarHeight: 0,
                shouldExtendBackground: false,
                setIntrinsicHeightOnNavigationControllers: false,
                useFullScreenMode: false,
                shrinkPresentingViewController: false,
                isRubberBandEnabled: false
            )
        )
        sheetController.cornerRadius = 28
        navigationController.present(sheetController, animated: true)
    }
}

// MARK: - Coordinator Finish Delegate
extension SheetCalendarCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}
