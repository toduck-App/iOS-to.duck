import UIKit
import Combine
import TDDesign
import TDCore

final class DiaryMakorViewController: BaseViewController<DiaryMakorView> {
    // MARK: - Properties
    private let viewModel: DiaryMakorViewModel
    private let input = PassthroughSubject<DiaryMakorViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: DiaryMakorCoordinator?
    
    // MARK: - Initializer
    init(
        viewModel: DiaryMakorViewModel
    ) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Common Methods
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .notificationScrollToBottom:
                    UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn) {
                        self?.layoutView.noticeSnackBarView.alpha = 1
                    } completion: { _ in
                        UIView.animate(withDuration: 1, delay: 4.0, options: .curveEaseOut) {
                            self?.layoutView.noticeSnackBarView.alpha = 0
                        }
                    }
                }
            }.store(in: &cancellables)
    }
    
    override func configure() {
        layoutView.diaryMoodCollectionView.delegate = self
    }
}

extension DiaryMakorViewController: DiaryMoodCollectionViewDelegate {
    func didTapCategoryCell(
        _ diaryMoodCollectionView: TDDesign.DiaryMoodCollectionView,
        selectedMood: UIImage
    ) {
        input.send(.tapCategoryCell(UIImage.reverseMoodDictionary[selectedMood] ?? "HAPPY"))
    }
}
