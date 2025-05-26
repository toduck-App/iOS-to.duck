public protocol UpdateUserNicknameUseCase {
    func execute(nickname: String) async throws
}

public final class UpdateUserNicknameUseCaseImpl: UpdateUserNicknameUseCase {
    private let repository: MyPageRepository
    
    public init(repository: MyPageRepository) {
        self.repository = repository
    }
    
    public func execute(nickname: String) async throws {
        try await repository.updateNickname(nickname: nickname)
    }
}
