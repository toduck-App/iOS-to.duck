public protocol RequestVerificationCodeForPasswordUseCase {
    func execute(loginId: String, phoneNumber: String) async throws
}

public final class RequestVerificationCodeForPasswordUseCaseImpl: RequestVerificationCodeForPasswordUseCase {
    private let repository: UserAuthRepository
    
    public init(repository: UserAuthRepository) {
        self.repository = repository
    }
    
    public func execute(loginId: String, phoneNumber: String) async throws {
        try await repository.requestFindPasswordVerificationCode(loginId: loginId, phoneNumber: phoneNumber)
    }
}
