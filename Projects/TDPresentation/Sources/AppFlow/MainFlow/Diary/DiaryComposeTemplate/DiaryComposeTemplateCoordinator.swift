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
        selectedDate: Date?,
        diary: Diary?
    ) {
        let viewModel = DiaryComposeTemplateViewModel()
        let diaryComposeTemplateViewController = DiaryComposeTemplateViewController(viewModel: viewModel)
        diaryComposeTemplateViewController.coordinator = self
        diaryComposeTemplateViewController.hidesBottomBarWhenPushed = true
        navigationController.pushTDViewController(diaryComposeTemplateViewController, animated: true)
    }
    
    func start() { }
}

// MARK: - Coordinator Finish Delegate
extension DiaryComposeTemplateCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}
