public protocol FindUserIdUseCase {
    func execute(phoneNumber: String) async throws -> String
}

public final class FindUserIdUseCaseImpl: FindUserIdUseCase {
    private let repository: UserAuthRepository
    
    public init(repository: UserAuthRepository) {
        self.repository = repository
    }
    
    public func execute(phoneNumber: String) async throws -> String {
        return try await repository.findId(phoneNumber: phoneNumber)
    }
}
