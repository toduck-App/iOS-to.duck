import FittedSheets
import UIKit
import TDCore
import TDDomain

final class SheetTimeCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable
    weak var delegate: SheetTimeDelegate?

    init(
        navigationController: UINavigationController,
        injector: DependencyResolvable
    ) {
        self.navigationController = navigationController
        self.injector = injector
    }

    func start() {
        let sheetViewController = SheetTimeViewController()
        sheetViewController.delegate = delegate
        sheetViewController.coordinator = self
        let sheetController = SheetViewController(
            controller: sheetViewController,
            sizes: [.fixed(600)],
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
        navigationController.present(sheetController, animated: true, completion: nil)
    }
}

// MARK: - Coordinator Finish Delegate
extension SheetTimeCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}
