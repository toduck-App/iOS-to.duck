// 회원가입 시 전화번호 인증 코드 요청 UseCase
public protocol RequestPhoneVerificationCodeUseCase {
    func execute(with phoneNumber: String) async throws
}

public final class RequestPhoneVerificationCodeUseCaseImpl: RequestPhoneVerificationCodeUseCase {
    private let repository: AuthRepository
    
    public init(repository: AuthRepository) {
        self.repository = repository
    }
    
    public func execute(with phoneNumber: String) async throws {
        try await repository.requestPhoneVerification(with: phoneNumber)
    }
}
