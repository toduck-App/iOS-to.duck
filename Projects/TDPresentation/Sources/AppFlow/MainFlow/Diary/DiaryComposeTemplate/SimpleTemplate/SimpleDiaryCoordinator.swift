import UIKit
import TDDomain
import TDDesign
import TDCore

protocol SimpleDiaryCoordinatorDelegate: AnyObject {
    /// 단순 뒤로가기 등으로 자식 코디네이터의 흐름이 끝났을 때 호출됩니다.
    func diaryEditCoordinatorDidFinish(_ coordinator: SimpleDiaryCoordinator)
    
    /// 일기 작성을 '완료'하고 흐름이 끝났을 때 호출됩니다.
    func diaryEditCoordinatorDidComplete(_ coordinator: SimpleDiaryCoordinator)
}

final class SimpleDiaryCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var finishDelegate: CoordinatorFinishDelegate?
    var injector: DependencyResolvable
    weak var delegate: SimpleDiaryCoordinatorDelegate?
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
        let viewModel = SimpleDiaryViewModel(
            createDiaryUseCase: createDiaryUseCase,
            updateDiaryUseCase: updateDiaryUseCase,
            selectedDate: selectedDate,
            preDiary: diary
        )
        let simpleDiaryViewController = SimpleDiaryViewController(viewModel: viewModel, isEdit: isEdit)
        simpleDiaryViewController.coordinator = self
        simpleDiaryViewController.hidesBottomBarWhenPushed = true
        navigationController.pushTDViewController(simpleDiaryViewController, animated: true)
        if let diary, isEdit {
            simpleDiaryViewController.updateEditView(preDiary: diary)
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
extension SimpleDiaryCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}
