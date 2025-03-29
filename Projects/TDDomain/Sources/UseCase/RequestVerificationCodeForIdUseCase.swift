// 아이디 찾기 인증번호 요청 UseCase
public protocol RequestVerificationCodeForIdUseCase {
    func execute(phoneNumber: String) async throws
}

public final class RequestVerificationCodeForIdUseCaseImpl: RequestVerificationCodeForIdUseCase {
    private let repository: UserAuthRepository
    
    public init(repository: UserAuthRepository) {
        self.repository = repository
    }
    
    public func execute(phoneNumber: String) async throws {
        try await repository.requestFindIdVerificationCode(phoneNumber: phoneNumber)
    }
}
