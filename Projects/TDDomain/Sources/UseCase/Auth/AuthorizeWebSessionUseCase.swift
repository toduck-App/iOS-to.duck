import TDCore

public protocol AuthorizeWebSessionUseCase {
    func execute(sessionToken: String) async throws
}

public struct AuthorizeWebSessionUseCaseImpl: AuthorizeWebSessionUseCase {
    private let repository: AuthRepository

    public init(repository: AuthRepository) {
        self.repository = repository
    }

    public func execute(sessionToken: String) async throws {
        try await repository.authorizeWebSession(sessionToken: sessionToken)
    }
}
