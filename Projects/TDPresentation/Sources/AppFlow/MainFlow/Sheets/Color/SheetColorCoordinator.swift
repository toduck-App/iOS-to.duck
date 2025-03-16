import FittedSheets
import UIKit
import TDCore
import TDDomain

final class SheetColorCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable
    var delegate: SheetColorDelegate?

    init(
        navigationController: UINavigationController,
        injector: DependencyResolvable
    ) {
        self.navigationController = navigationController
        self.injector = injector
    }

    func start() {
        let fetchCategoriesUseCase = injector.resolve(FetchCategoriesUseCase.self)
        let updateCategoriesUseCase = injector.resolve(UpdateCategoriesUseCase.self)
        let viewModel = SheetColorViewModel(
            fetchCategoriesUseCase: fetchCategoriesUseCase,
            updateCategoriesUseCase: updateCategoriesUseCase
        )
        let sheetViewController = SheetColorViewController(viewModel: viewModel)
        sheetViewController.coordinator = self
        sheetViewController.delegate = delegate
        let sheetController = SheetViewController(
            controller: sheetViewController,
            sizes: [.fixed(650)],
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
extension SheetColorCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}

extension SheetColorCoordinator: SheetColorDelegate {
    func didSaveCategory() {
        delegate?.didSaveCategory()
    }
}
