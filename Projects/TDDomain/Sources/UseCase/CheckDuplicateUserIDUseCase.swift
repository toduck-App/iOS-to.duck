public protocol CheckDuplicateUserIdUseCase {
    func execute(loginId: String) async throws
}

final class CheckDuplicateUserIdUseCaseImpl: CheckDuplicateUserIdUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func execute(loginId: String) async throws {
        try await repository.checkDuplicateUserID(loginId: loginId)
    }
}
