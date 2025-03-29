import UIKit
import TDDomain
import TDDesign
import TDCore

final class DiaryMakorCoordinator: Coordinator {
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
        let viewModel = DiaryMakorViewModel(selectedDate: selectedDate, preDiary: diary)
        let diaryMakorViewController = DiaryMakorViewController(viewModel: viewModel, isEdit: isEdit)
        diaryMakorViewController.coordinator = self
        diaryMakorViewController.hidesBottomBarWhenPushed = true
        navigationController.pushTDViewController(diaryMakorViewController, animated: true)
        if let diary, isEdit {
            diaryMakorViewController.updateEditView(preDiary: diary)
        }
    }
    
    func start() { }
}

// MARK: - Coordinator Finish Delegate
extension DiaryMakorCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}
