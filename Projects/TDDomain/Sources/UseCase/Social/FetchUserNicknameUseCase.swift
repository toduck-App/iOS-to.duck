public protocol FetchUserNicknameUseCase {
    func execute() async throws -> String
}

public final class FetchUserNicknameUseCaseImpl: FetchUserNicknameUseCase {
    private let repository: MyPageRepository
    
    public init(repository: MyPageRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> String {
        try await repository.fetchNickname()
    }
}
