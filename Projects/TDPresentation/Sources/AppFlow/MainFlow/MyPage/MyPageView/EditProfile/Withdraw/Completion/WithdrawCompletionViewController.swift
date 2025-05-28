import Combine
import UIKit

final class WithdrawCompletionViewController: BaseViewController<WithdrawCompletionView> {
    weak var coordinator: WithdrawCompletionCoordinator?
    let viewModel: WithdrawCompletionViewModel!
    
    private let input = PassthroughSubject<WithdrawCompletionViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(
        viewModel: WithdrawCompletionViewModel
    ) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        layoutView.delegate = self
        layoutView.backgroundColor = .white
        navigationController?.setupNestedNavigationBar(
            leftButtonTitle: "회원 탈퇴",
            leftButtonAction: UIAction { _ in
                self.coordinator?.popViewController()
            }
        )
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .withdrawCompleted:
                    NotificationCenter.default.post(name: .userRefreshTokenExpired, object: nil)
                case .failure(let error):
                    self.showErrorAlert(errorMessage: error)
                }
            }
            .store(in: &cancellables)
    }
}

extension WithdrawCompletionViewController: WithdrawCompletionViewDelegate {
    func WithdrawCompletionViewDidTapNextButton(_ view: WithdrawCompletionView) {
        input.send(.didTapWithdrawCompleteButton)
    }
}
