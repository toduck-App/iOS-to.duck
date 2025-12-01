import UIKit
import TDDomain
import TDDesign
import TDCore

final class DiaryEmotionCoordinator: Coordinator {
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
        let viewModel = DiaryEmotionViewModel(selectedDate: selectedDate)
        let diaryEmotionViewController = DiaryEmotionViewController(viewModel: viewModel)
        diaryEmotionViewController.coordinator = self
        diaryEmotionViewController.hidesBottomBarWhenPushed = true
        navigationController.pushTDViewController(diaryEmotionViewController, animated: true)
    }
    
    func showKeywordDiaryCompose(selectedMood: Emotion, selectedDate: Date) {
        let diaryKeywordCoordinator = DiaryKeywordCoordinator(
            navigationController: navigationController,
            injector: injector,
            isEdit: isEdit
        )
        diaryKeywordCoordinator.finishDelegate = self
        childCoordinators.append(diaryKeywordCoordinator)
        finishDelegate?.didFinish(childCoordinator: self)
        diaryKeywordCoordinator.start(selectedMood: selectedMood, selectedDate: selectedDate)
    }
    
    func showSimpleDiaryCompose(selectedDate: Date?, diary: Diary?) {
        let diaryEditCoordinator = SimpleDiaryCoordinator(
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

extension DiaryEmotionCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}

// MARK: - DiaryEditCoordinator Delegate

extension DiaryEmotionCoordinator: SimpleDiaryCoordinatorDelegate {
    func diaryEditCoordinatorDidFinish(_ coordinator: SimpleDiaryCoordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
    
    func diaryEditCoordinatorDidComplete(_ coordinator: SimpleDiaryCoordinator) {
        childCoordinators.removeAll { $0 === coordinator }
        popViewController()
    }
}
