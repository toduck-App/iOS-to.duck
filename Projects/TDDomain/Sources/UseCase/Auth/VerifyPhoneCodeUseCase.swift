public protocol VerifyPhoneCodeUseCase {
    func execute(phoneNumber: String, verifiedCode: String) async throws
}

public final class VerifyPhoneCodeUseCaseImpl: VerifyPhoneCodeUseCase {
    private let repository: AuthRepository
    
    public init(repository: AuthRepository) {
        self.repository = repository
    }
    
    public func execute(phoneNumber: String, verifiedCode: String) async throws {
        try await repository.checkPhoneVerification(phoneNumber: phoneNumber, verifiedCode: verifiedCode)
    }
}
