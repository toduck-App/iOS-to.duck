import UIKit
import TDDomain
import TDDesign
import TDCore

final class DiaryMakorCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable
    private let selectedDate: Date

    init(
        navigationController: UINavigationController,
        injector: DependencyResolvable,
        selectedDate: Date
    ) {
        self.navigationController = navigationController
        self.injector = injector
        self.selectedDate = selectedDate
    }
    
    func start() {
        let viewModel = DiaryMakorViewModel()
        let diaryMakorViewController = DiaryMakorViewController(viewModel: viewModel)
        diaryMakorViewController.coordinator = self
        navigationController.pushTDViewController(diaryMakorViewController, animated: true)
    }
}

// MARK: - Coordinator Finish Delegate
extension DiaryMakorCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}
