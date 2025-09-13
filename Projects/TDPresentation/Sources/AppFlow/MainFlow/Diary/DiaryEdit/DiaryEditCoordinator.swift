import UIKit
import TDDomain
import TDDesign
import TDCore

protocol DiaryEditCoordinatorDelegate: AnyObject {
    /// 단순 뒤로가기 등으로 자식 코디네이터의 흐름이 끝났을 때 호출됩니다.
    func diaryEditCoordinatorDidFinish(_ coordinator: DiaryEditCoordinator)
    
    /// 일기 작성을 '완료'하고 흐름이 끝났을 때 호출됩니다.
    func diaryEditCoordinatorDidComplete(_ coordinator: DiaryEditCoordinator)
}

final class DiaryEditCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable
    weak var delegate: DiaryEditCoordinatorDelegate?
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
    
    func popViewController() {
        navigationController.popViewController(animated: true)
        delegate?.diaryEditCoordinatorDidFinish(self)
    }
    
    func completeAndPopViewController() {
        navigationController.popViewController(animated: true)
        delegate?.diaryEditCoordinatorDidComplete(self)
    }
    
    func start() { }
}

// MARK: - Coordinator Finish Delegate
extension DiaryEditCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}
