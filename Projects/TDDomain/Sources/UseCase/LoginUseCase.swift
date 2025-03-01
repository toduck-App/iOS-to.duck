import Foundation

public protocol LoginUseCase {
    func execute(loginId: String, password: String) async throws
}

public final class LoginUseCaseImpl: LoginUseCase {
    
    private let repository: AuthRepository

    public init(repository: AuthRepository) {
        self.repository = repository
    }
    
    public func execute(loginId: String, password: String) async throws {
        try await repository.requestLogin(loginId: loginId, password: password).get()
    }
}
