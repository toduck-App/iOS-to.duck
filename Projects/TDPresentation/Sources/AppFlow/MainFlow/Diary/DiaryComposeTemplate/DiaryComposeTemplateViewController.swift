import UIKit
import Combine
import SnapKit
import Then
import TDDesign

final class DiaryComposeTemplateViewController: BaseViewController<DiaryComposeTemplateView> {
    
    // MARK: - UI Components
    
    let navigationProgressView = NavigationProgressView()
    
    let pageLabel = TDLabel(
        labelText: "1 / 3",
        toduckFont: .mediumHeader4,
        toduckColor: TDColor.Neutral.neutral600,
    )
    
    // MARK: - Properties
    
    private let viewModel: DiaryComposeTemplateViewModel
    private let input = PassthroughSubject<DiaryComposeTemplateViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: DiaryComposeTemplateCoordinator?
    
    // MARK: - Initializers
    
    init(viewModel: DiaryComposeTemplateViewModel) {
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
        
        removeProgressViewFromNavigationBar()
    }
    
    // MARK: - Common Methods
    
    override func configure() {
        configurePagingNavigationBar(currentPage: 1, totalPages: 3)
        let emotionItems = viewModel.emotions.map { EmotionItem(image: $0.image.withRenderingMode(.alwaysOriginal)) }
        layoutView.emotionGridView.configure(with: emotionItems)
        layoutView.emotionGridView.onEmotionTapped = { [weak self] tappedIndex in
            guard let self else { return }
            HapticManager.impact(.soft)
            
            // 이미 선택된 버튼을 다시 탭한 경우 -> 선택 해제
            if viewModel.selectedEmotionIndex == tappedIndex {
                layoutView.emotionGridView.updateSelectionState(selectedIndex: nil)
                input.send(.selectEmotion(nil))
                layoutView.setNextButtonActive(false)
            } else {
                // 새로운 버튼을 탭한 경우 -> 선택
                layoutView.emotionGridView.updateSelectionState(selectedIndex: tappedIndex)
                input.send(.selectEmotion(tappedIndex))
                layoutView.setNextButtonActive(true)
            }
        }
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

extension DiaryComposeTemplateViewController: PagingNavigationBarConfigurable { }
