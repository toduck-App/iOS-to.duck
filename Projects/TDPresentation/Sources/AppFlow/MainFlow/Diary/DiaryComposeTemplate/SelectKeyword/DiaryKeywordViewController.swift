import UIKit
import Combine

final class DiaryKeywordViewController: BaseViewController<DiaryKeywordView> {
    // MARK: - Properties
    
    private let viewModel: DiaryKeywordViewModel
    private let input = PassthroughSubject<DiaryKeywordViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: DiaryKeywordCoordinator?
    
    // MARK: - Initializer
    
    init(
        viewModel: DiaryKeywordViewModel
    ) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
