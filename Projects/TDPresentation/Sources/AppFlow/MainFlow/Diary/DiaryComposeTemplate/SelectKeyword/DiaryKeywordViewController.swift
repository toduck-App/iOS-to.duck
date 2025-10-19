import UIKit
import Combine
import TDDesign

final class DiaryKeywordViewController: BaseViewController<DiaryKeywordView> {
    
    // MARK: - UI Components
    
    let navigationProgressView = NavigationProgressView()
    
    let pageLabel = TDLabel(
        labelText: "2 / 3",
        toduckFont: .mediumHeader4,
        toduckColor: TDColor.Neutral.neutral600,
    )
    
    // MARK: - Properties
    
    private let viewModel: DiaryKeywordViewModel
    private let input = PassthroughSubject<DiaryKeywordViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: DiaryKeywordCoordinator?
    
    // MARK: - Initializer
    
    init(viewModel: DiaryKeywordViewModel) {
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
        // 기존의 scrollView 관련 코드는 제거
        configurePagingNavigationBar(currentPage: 2, totalPages: 3)
    }
}

// MARK: - PagingNavigationBarConfigurable

extension DiaryKeywordViewController: PagingNavigationBarConfigurable { }
