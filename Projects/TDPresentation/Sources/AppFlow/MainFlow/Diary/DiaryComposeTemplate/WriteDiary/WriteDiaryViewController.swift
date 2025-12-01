import UIKit
import TDDomain
import Combine
import TDDesign

final class WriteDiaryViewController: BaseViewController<WriteDiaryView> {
    
    
    // MARK: - UI Components
    
    let navigationProgressView = NavigationProgressView()
    
    let pageLabel = TDLabel(
        labelText: "3 / 3",
        toduckFont: .mediumHeader4,
        toduckColor: TDColor.Neutral.neutral600,
    )
    
    // MARK: - Properties
    
    private let viewModel: WriteDiaryViewModel
    private let input = PassthroughSubject<WriteDiaryViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: WriteDiaryCoordinator?
    
    // MARK: - Initializer
    
    init(viewModel: WriteDiaryViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Life Cycle
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Common Methods
    
    override func configure() {
        configurePagingNavigationBar(currentPage: 3, totalPages: 3)
    }
    
    override func binding() {
        super.binding()
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
            }.store(in: &cancellables)
    }
}

// MARK: - PagingNavigationBarConfigurable

extension WriteDiaryViewController: PagingNavigationBarConfigurable { }
