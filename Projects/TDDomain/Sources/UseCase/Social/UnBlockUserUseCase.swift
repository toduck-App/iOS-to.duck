import Foundation

public protocol UnBlockUserUseCase {
    func execute(userID: User.ID) async throws
}

public final class UnBlockUserUseCaseImpl: UnBlockUserUseCase {
    private let repository: UserRepository

    public init(repository: UserRepository) {
        self.repository = repository
    }

    public func execute(userID: User.ID) async throws {
        try await repository.unBlockUser(userID: userID)
    }
}
