public protocol WithdrawUseCase {
    func execute(type: WithdrawReasonType, reason: String) async throws
}

public final class WithdrawUseCaseImpl: WithdrawUseCase {
    private let repository: UserAuthRepository

    public init(repository: UserAuthRepository) {
        self.repository = repository
    }

    public func execute(type: WithdrawReasonType, reason: String) async throws {
        try await repository.withdraw(type: type, reason: reason)
    }
}
