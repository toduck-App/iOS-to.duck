// 아이디/비밀번호 찾기 인증번호 요청 UseCase
public protocol RequestVerificationCodeForFindUserUseCase {
    func execute(phoneNumber: String) async throws
}

public final class RequestVerificationCodeForFindUserUseCaseImpl: RequestVerificationCodeForFindUserUseCase {
    private let repository: UserAuthRepository
    
    public init(repository: UserAuthRepository) {
        self.repository = repository
    }
    
    public func execute(phoneNumber: String) async throws {
        try await repository.requestFindIdVerificationCode(phoneNumber: phoneNumber)
    }
}
