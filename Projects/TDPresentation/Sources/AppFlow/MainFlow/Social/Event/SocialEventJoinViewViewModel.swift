import Combine
import TDCore
import TDDomain

final class SocialEventJoinViewModel: BaseViewModel {

    enum Input {
        case joinEvent(String)
    }

    enum Output {
        case success
        case error(String)
    }

    let output = PassthroughSubject<Output, Never>()
    let socialId: Int
    let participateEventUseCase: ParticipateEventUseCase
    var cancellables: Set<AnyCancellable> = []

    init(
        participateEventUseCase: ParticipateEventUseCase,
        socialId: Int

    ) {
        self.participateEventUseCase = participateEventUseCase
        self.socialId = socialId
    }

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<
        Output, Never
    > {

        input.sink { [weak self] event in
            switch event {

            case .joinEvent(let phoneNumber):
                Task { await self?.joinEvent(phoneNumber: phoneNumber) }
            }
        }.store(in: &cancellables)

        return output.eraseToAnyPublisher()
    }

    private func joinEvent(phoneNumber: String) async {
        do {
            try await participateEventUseCase.execute(
                socialId: socialId,
                phone: phoneNumber
            )
            output.send(.success)
        } catch {
            output.send(.error(error.localizedDescription))
        }
    }

}
