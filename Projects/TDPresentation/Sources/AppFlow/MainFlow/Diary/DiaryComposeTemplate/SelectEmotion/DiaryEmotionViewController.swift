import UIKit
import Combine
import SnapKit
import Then
import TDDesign

final class DiaryEmotionViewController: BaseViewController<DiaryEmotionView> {
    
    // MARK: - UI Components
    
    let navigationProgressView = NavigationProgressView()
    
    let pageLabel = TDLabel(
        labelText: "1 / 3",
        toduckFont: .mediumHeader4,
        toduckColor: TDColor.Neutral.neutral600,
    )
    
    // MARK: - Properties
    
    private let viewModel: DiaryEmotionViewModel
    private let input = PassthroughSubject<DiaryEmotionViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: DiaryEmotionCoordinator?
    
    // MARK: - Initializers
    
    init(viewModel: DiaryEmotionViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Common Methods
    
    override func configure() {
        configurePagingNavigationBar(currentPage: 1, totalPages: 3)
        configureEmotionGrid()
        configureButtonActions()
    }
    
    private func configureEmotionGrid() {
        let emotionItems = viewModel.emotions.map { EmotionItem(image: $0.largeImage.withRenderingMode(.alwaysOriginal)) }
        layoutView.emotionGridView.configure(with: emotionItems)
        
        layoutView.emotionGridView.onEmotionTapped = { [weak self] tappedIndex in
            guard let self = self else { return }
            HapticManager.impact(.soft)
            
            if self.viewModel.selectedEmotionIndex == tappedIndex {
                // 선택 해제
                self.layoutView.emotionGridView.updateSelectionState(selectedIndex: nil)
                self.input.send(.selectEmotion(nil))
                self.layoutView.setNextButtonActive(false)
            } else {
                // 새로운 감정 선택
                self.layoutView.emotionGridView.updateSelectionState(selectedIndex: tappedIndex)
                self.input.send(.selectEmotion(tappedIndex))
                self.layoutView.setNextButtonActive(true)
            }
        }
    }
    
    private func configureButtonActions() {
        layoutView.nextButton.addAction(UIAction { [weak self] _ in
            guard
                let selectedEmotion = self?.viewModel.currentSelectedEmotion,
                let selectedDate = self?.viewModel.selectedDate
            else { return }
            
            self?.coordinator?.showKeywordDiaryCompose(selectedMood: selectedEmotion, selectedDate: selectedDate)
        }, for: .touchUpInside)
        
        layoutView.simpleDiaryButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.showSimpleDiaryCompose(selectedDate: self?.viewModel.selectedDate, diary: nil)
        }, for: .touchUpInside)
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .selectedEmotion(let comment):
                    self?.layoutView.configureCommentLabel(comment ?? "")
                }
            }.store(in: &cancellables)
    }
}

// MARK: - PagingNavigationBarConfigurable

extension DiaryEmotionViewController: PagingNavigationBarConfigurable { }
