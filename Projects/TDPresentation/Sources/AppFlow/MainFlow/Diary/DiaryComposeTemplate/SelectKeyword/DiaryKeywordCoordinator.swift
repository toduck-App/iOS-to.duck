import UIKit
import TDDomain
import TDDesign
import TDCore

final class DiaryKeywordCoordinator: Coordinator {
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
        selectedMood: Emotion,
        selectedDate: Date
    ) {
        let fetchDiaryKeywordsUseCase = injector.resolve(FetchDiaryKeywordUseCase.self)
        let createDiaryKeywordUseCase = injector.resolve(CreateDiaryKeywordUseCase.self)
        let deleteDiaryKeywordUseCase = injector.resolve(DeleteDiaryKeywordUseCase.self)
        let viewModel = DiaryKeywordViewModel(
            selectedMood: selectedMood,
            selectedDate: selectedDate,
            fetchDiaryKeywordsUseCase: fetchDiaryKeywordsUseCase,
            createDiaryKeywordUseCase: createDiaryKeywordUseCase,
            deleteDiaryKeywordUseCase: deleteDiaryKeywordUseCase
        )
        let diaryEmotionViewController = DiaryKeywordViewController(viewModel: viewModel)
        diaryEmotionViewController.coordinator = self
        diaryEmotionViewController.hidesBottomBarWhenPushed = true
        navigationController.pushTDViewController(diaryEmotionViewController, animated: true)
    }
    
    func showWriteDiaryCompose(
        selectedMood: Emotion,
        selectedDate: Date,
        selectedKeywords: [UserKeyword]
    ) {
        let writeDiaryCoordinator = WriteDiaryCoordinator(
            navigationController: navigationController,
            injector: injector
        )
        writeDiaryCoordinator.start(
            selectedMood: selectedMood,
            selectedDate: selectedDate,
            selectedKeyword: selectedKeywords
        )
        writeDiaryCoordinator.finishDelegate = self
        childCoordinators.append(writeDiaryCoordinator)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
        finishDelegate?.didFinish(childCoordinator: self)
    }
    
    func start() { }
}

// MARK: - Coordinator Finish Delegate

extension DiaryKeywordCoordinator: CoordinatorFinishDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
        finishDelegate?.didFinish(childCoordinator: self)
    }
}
