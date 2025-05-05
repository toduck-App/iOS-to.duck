import Combine
import TDDomain

final class WithdrawCompletionViewModel: BaseViewModel {
    enum Input {
        case didTapWithdrawCompleteButton
    }

    enum Output {
        case withdrawCompleted
        case failure(String)
    }

    private let withdrawUseCase: WithdrawUseCase
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private var type: WithdrawReasonType
    private var reason: String
    
    init(
        withdrawUseCase: WithdrawUseCase,
        type: WithdrawReasonType,
        reason: String
    ) {
        self.withdrawUseCase = withdrawUseCase
        self.type = type
        self.reason = reason
    }

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .didTapWithdrawCompleteButton:
                Task { await self.withdraw() }
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func withdraw() async {
        do {
            try await withdrawUseCase.execute(type: type, reason: reason)
            output.send(.withdrawCompleted)
        } catch {
            output.send(.failure(error.localizedDescription))
        }
    }
}
