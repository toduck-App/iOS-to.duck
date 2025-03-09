import TDCore

public protocol KakaoLoginUseCase {
    func execute() async throws
}

public struct KakaoLoginUseCaseImpl: KakaoLoginUseCase {
    private let repository: AuthRepository
    
    public init(repository: AuthRepository) {
        self.repository = repository
    }
    
    public func execute() async throws {
        try await repository.requestKakaoLogin()
    }
}
