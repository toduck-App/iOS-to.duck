// 아이디와 인증된 휴대폰번호 검증
public protocol RequestValidFindUserUseCase {
    func execute(loginId: String, phoneNumber: String) async throws
}

public final class RequestValidFindUserUseCaseImpl: RequestValidFindUserUseCase {
    private let repository: UserAuthRepository
    
    public init(repository: UserAuthRepository) {
        self.repository = repository
    }
    
    public func execute(loginId: String, phoneNumber: String) async throws {
        try await repository.requestFindPasswordVerificationCode(loginId: loginId, phoneNumber: phoneNumber)
    }
}
