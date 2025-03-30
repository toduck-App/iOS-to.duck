public protocol RegisterUserUseCase {
    func execute(user: RegisterUser) async throws
}

public final class RegisterUserUseCaseImpl: RegisterUserUseCase {
    private let repository: AuthRepository
    
    public init(repository: AuthRepository) {
        self.repository = repository
    }
    
    public func execute(user: RegisterUser) async throws {
        try await repository.requestRegisterUser(user: user)
    }
}
