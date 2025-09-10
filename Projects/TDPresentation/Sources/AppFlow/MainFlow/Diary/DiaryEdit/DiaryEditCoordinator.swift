import UIKit
import TDDomain
import TDDesign
import TDCore

final class DiaryEditCoordinator: Coordinator {
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
        selectedDate: Date?,
        diary: Diary?
    ) {
        let createDiaryUseCase = injector.resolve(CreateDiaryUseCase.self)
        let updateDiaryUseCase = injector.resolve(UpdateDiaryUseCase.self)
        let viewModel = DiaryEditViewModel(
            createDiaryUseCase: createDiaryUseCase,
            updateDiaryUseCase: updateDiaryUseCase,
            selectedDate: selectedDate,
            preDiary: diary
        )
        let diaryEditViewController = DiaryEditViewController(viewModel: viewModel, isEdit: isEdit)
        diaryEditViewController.coordinator = self
        diaryEditViewController.hidesBottomBarWhenPushed = true
        navigationController.pushTDViewController(diaryEditViewController, animated: true)
        if let diary, isEdit {
            diaryEditViewController.updateEditView(preDiary: diary)
        }
    }
    
    func start() { }
}

// MARK: - Coordinator Finish Delegate
extension DiaryEditCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}
