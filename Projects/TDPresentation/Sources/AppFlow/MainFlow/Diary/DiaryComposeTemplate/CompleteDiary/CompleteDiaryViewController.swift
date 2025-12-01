import UIKit
import TDDomain
import Combine
import TDDesign

final class CompleteDiaryViewController: BaseViewController<CompleteDiaryView> {
    
    // MARK: - Properties
    
    private let viewModel: CompleteDiaryViewModel
    private let input = PassthroughSubject<CompleteDiaryViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: CompleteDiaryCoordinator?
    
    // MARK: - Initializer
    
    init(viewModel: CompleteDiaryViewModel) {
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
        layoutView.doneButton.addAction(UIAction { [weak self] _ in
            guard let self, let coordinator else { return }
            coordinator.finishDelegate?.didFinish(childCoordinator: coordinator)
        }, for: .touchUpInside)
    }
    
    override func binding() {
        super.binding()
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .streak(let streakCount):
                    print("Streak Count = \(streakCount) ")
                case .failure(let message):
                    layoutView.doneButton.isEnabled = true
                    showErrorAlert(errorMessage: message)
                }
            }.store(in: &cancellables)
    }
}
