import FittedSheets
import TDCore
import TDDomain
import UIKit

protocol SocialSelectRoutineDelegate {
    func didTapRoutine(_ routine: Routine)
}

final class SocialSelectRoutineCoordinator: Coordinator {
    var delegate: SocialSelectRoutineDelegate?
    var navigationController: UINavigationController
    var childCoordinators = [any Coordinator]()
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
        let fetchAvailableRoutineListUseCase = injector.resolve(FetchAvailableRoutineListUseCase.self)
        let viewModel = SocialSelectRoutineViewModel(fetchAvailableRoutineListUseCase: fetchAvailableRoutineListUseCase)
        let controller = SocialSelectRoutineViewController(viewModel: viewModel)
        let sheetController = SheetViewController(
            controller: controller,
            sizes: [.fixed(680)],
            options: .init(
                pullBarHeight: 0,
                shouldExtendBackground: false,
                setIntrinsicHeightOnNavigationControllers: false,
                useFullScreenMode: false,
                shrinkPresentingViewController: false,
                isRubberBandEnabled: false
            )
        )
        controller.coordinator = self
        sheetController.cornerRadius = 28
        navigationController.present(sheetController, animated: true, completion: nil)
    }
    func didTapRoutine(_ routine: Routine) {
        delegate?.didTapRoutine(routine)
        navigationController.dismiss(animated: true, completion: nil)
    }
}
