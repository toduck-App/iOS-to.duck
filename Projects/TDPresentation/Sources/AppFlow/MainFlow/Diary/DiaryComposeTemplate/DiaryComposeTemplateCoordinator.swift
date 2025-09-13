import UIKit
import TDDomain
import TDDesign
import TDCore

final class DiaryComposeTemplateCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable
    private let isEdit: Bool

    init(
        navigationController: UINavigationController,
        injector: DependencyResolvable,
        isEdit: Bool
    ) {
        self.navigationController = navigationController
        self.injector = injector
        self.isEdit = isEdit
    }
    
    func start(
        selectedDate: Date
    ) {
        let viewModel = DiaryComposeTemplateViewModel(selectedDate: selectedDate)
        let diaryComposeTemplateViewController = DiaryComposeTemplateViewController(viewModel: viewModel)
        diaryComposeTemplateViewController.coordinator = self
        diaryComposeTemplateViewController.hidesBottomBarWhenPushed = true
        navigationController.pushTDViewController(diaryComposeTemplateViewController, animated: true)
    }
    
    func showSimpleDiaryCompose(selectedDate: Date?, diary: Diary?) {
        let diaryEditCoordinator = DiaryEditCoordinator(
            navigationController: navigationController,
            injector: injector,
            isEdit: isEdit
        )
        diaryEditCoordinator.finishDelegate = self
        diaryEditCoordinator.delegate = self
        childCoordinators.append(diaryEditCoordinator)
        finishDelegate?.didFinish(childCoordinator: self)
        diaryEditCoordinator.start(selectedDate: selectedDate, diary: diary)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
        finishDelegate?.didFinish(childCoordinator: self)
    }
    
    func start() { }
}

// MARK: - Coordinator Finish Delegate

extension DiaryComposeTemplateCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}

// MARK: - DiaryEditCoordinator Delegate

extension DiaryComposeTemplateCoordinator: DiaryEditCoordinatorDelegate {
    func diaryEditCoordinatorDidFinish(_ coordinator: DiaryEditCoordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
    
    func diaryEditCoordinatorDidComplete(_ coordinator: DiaryEditCoordinator) {
        childCoordinators.removeAll { $0 === coordinator }
        popViewController()
    }
}
