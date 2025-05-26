import UIKit
import TDDomain
import TDCore

protocol DiaryCoordinatorDelegate: AnyObject {
    func didTapCreateDiaryButton(selectedDate: Date)
    func didTapEditDiaryButton(diary: Diary)
}

final class DiaryCoordinator: Coordinator {
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

    func start() {
        let fetchUserNicknameUseCase = injector.resolve(FetchUserNicknameUseCase.self)
        let fetchDiaryCompareCountUseCase = injector.resolve(FetchDiaryCompareCountUseCase.self)
        let fetchFocusPercentUseCase = injector.resolve(FetchFocusPercentUseCase.self)
        let viewModel = DiaryViewModel(
            fetchUserNicknameUseCase: fetchUserNicknameUseCase,
            fetchDiaryCompareCountUseCase: fetchDiaryCompareCountUseCase,
            fetchFocusPercentUseCase: fetchFocusPercentUseCase
        )
        let diaryViewController = DiaryViewController(viewModel: viewModel)
        diaryViewController.coordinator = self
        navigationController.pushViewController(diaryViewController, animated: false)
    }
    
    func didTapHomeTomatoIcon() {
        (finishDelegate as? MainTabBarCoordinator)?.switchToHomeTab()
    }
    
    func didTapAlarmButton() {
        let notificationCoordinator = NotificationCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        notificationCoordinator.finishDelegate = self
        childCoordinators.append(notificationCoordinator)
        notificationCoordinator.start()
    }
}

// MARK: - Coordinator Finish Delegate
extension DiaryCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}

// MARK: - Diary Coordinator Delegate
extension DiaryCoordinator: DiaryCoordinatorDelegate {
    func didTapCreateDiaryButton(selectedDate: Date) {
        let diaryMakorCoordinator = DiaryCreatorCoordinator(
            navigationController: navigationController,
            injector: injector,
            isEdit: false
        )
        diaryMakorCoordinator.finishDelegate = self
        childCoordinators.append(diaryMakorCoordinator)
        diaryMakorCoordinator.start(selectedDate: selectedDate, diary: nil)
    }
    
    func didTapEditDiaryButton(diary: Diary) {
        let diaryMakorCoordinator = DiaryCreatorCoordinator(
            navigationController: navigationController,
            injector: injector,
            isEdit: true
        )
        diaryMakorCoordinator.finishDelegate = self
        childCoordinators.append(diaryMakorCoordinator)
        diaryMakorCoordinator.start(selectedDate: nil, diary: diary)
    }
}
