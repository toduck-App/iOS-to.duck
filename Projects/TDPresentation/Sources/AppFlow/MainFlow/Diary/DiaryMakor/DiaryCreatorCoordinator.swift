import UIKit
import TDDomain
import TDDesign
import TDCore

final class DiaryCreatorCoordinator: Coordinator {
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
        let viewModel = DiaryCreatorViewModel(
            createDiaryUseCase: createDiaryUseCase,
            updateDiaryUseCase: updateDiaryUseCase,
            selectedDate: selectedDate,
            preDiary: diary
        )
        let diaryCreatorViewController = DiaryCreatorViewController(viewModel: viewModel, isEdit: isEdit)
        diaryCreatorViewController.coordinator = self
        diaryCreatorViewController.hidesBottomBarWhenPushed = true
        navigationController.pushTDViewController(diaryCreatorViewController, animated: true)
        if let diary, isEdit {
            diaryCreatorViewController.updateEditView(preDiary: diary)
        }
    }
    
    func start() { }
}

// MARK: - Coordinator Finish Delegate
extension DiaryCreatorCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}
