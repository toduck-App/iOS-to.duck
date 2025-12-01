import UIKit
import TDDomain
import TDDesign
import TDCore

final class WriteDiaryCoordinator: Coordinator {
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
    
    func start(
        selectedMood: String,
        selectedDate: Date,
        selectedKeyword: [DiaryKeyword]
    ) {
        let vm = WriteDiaryViewModel(
            selectedMood: selectedMood,
            selectedDate: selectedDate,
            selectedKeyword: selectedKeyword
        )
        let vc = WriteDiaryViewController(viewModel: vm)
        vc.coordinator = self
        navigationController.pushTDViewController(vc, animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
        finishDelegate?.didFinish(childCoordinator: self)
    }
    
    func start() { }
}

// MARK: - Coordinator Finish Delegate

extension WriteDiaryCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}
