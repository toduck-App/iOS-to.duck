public protocol UserLogoutUseCase {
    func execute() async throws
}

public final class UserLogoutUseCaseImpl: UserLogoutUseCase {
    private let repository: UserAuthRepository

    public init(repository: UserAuthRepository) {
        self.repository = repository
    }

    public func execute() async throws {
        try await repository.logout()
    }
}
