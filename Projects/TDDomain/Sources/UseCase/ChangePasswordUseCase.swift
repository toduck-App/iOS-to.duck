public protocol ChangePasswordUseCase {
    func execute(loginId: String, changedPassword: String, phoneNumber: String) async throws
}

public final class ChangePasswordUseCaseImpl: ChangePasswordUseCase {
    private let repository: UserAuthRepository
    
    public init(repository: UserAuthRepository) {
        self.repository = repository
    }
    
    public func execute(
        loginId: String,
        changedPassword: String,
        phoneNumber: String
    ) async throws {
        try await repository.changePassword(
            loginId: loginId,
            changedPassword: changedPassword,
            phoneNumber: phoneNumber
        )
    }
}
