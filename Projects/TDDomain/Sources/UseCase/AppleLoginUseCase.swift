public protocol AppleLoginUseCase {
    func execute(oauthId: String, idToken: String) async throws
}

public struct AppleLoginUseCaseImpl: AppleLoginUseCase {
    private let repository: AuthRepository

    public init(repository: AuthRepository) {
        self.repository = repository
    }
    
    public func execute(oauthId: String, idToken: String) async throws {
        try await repository.requestAppleLogin(oauthId: oauthId, idToken: idToken)
    }
}
