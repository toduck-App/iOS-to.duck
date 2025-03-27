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
    private let isEdit: Bool

    init(
        navigationController: UINavigationController,
        injector: DependencyResolvable,
        selectedDate: Date,
        isEdit: Bool
    ) {
        self.navigationController = navigationController
        self.injector = injector
        self.selectedDate = selectedDate
        self.isEdit = isEdit
    }
    
    func start() {
        let viewModel = DiaryMakorViewModel()
        let diaryMakorViewController = DiaryMakorViewController(viewModel: viewModel, isEdit: isEdit)
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
