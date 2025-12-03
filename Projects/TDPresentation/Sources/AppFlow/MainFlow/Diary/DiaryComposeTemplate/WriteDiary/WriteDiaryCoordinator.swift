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
        selectedMood: Emotion,
        selectedDate: Date,
        selectedKeyword: [UserKeyword]
    ) {
        let createDiaryUseCase = injector.resolve(CreateDiaryUseCase.self)
        let vm = WriteDiaryViewModel(
            selectedMood: selectedMood,
            selectedDate: selectedDate,
            selectedKeyword: selectedKeyword,
            createDiaryUseCase: createDiaryUseCase
        )
        let vc = WriteDiaryViewController(viewModel: vm)
        vc.coordinator = self
        navigationController.pushTDViewController(vc, animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
        finishDelegate?.didFinish(childCoordinator: self)
    }
    
    func showCompleteDiaryView() {
        let coordinator = CompleteDiaryCoordinator(navigationController: navigationController, injector: injector)
        childCoordinators.append(coordinator)
        coordinator.finishDelegate = self
        coordinator.start()
    }
    
    func start() { }
}

// MARK: - Coordinator Finish Delegate

extension WriteDiaryCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
        finishDelegate?.didFinish(childCoordinator: self)
    }
}
