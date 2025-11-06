import Foundation

public protocol BlockUserUseCase {
    func execute(userID: User.ID) async throws
}

public final class BlockUserUseCaseImpl: BlockUserUseCase {
    private let repository: UserRepository

    public init(repository: UserRepository) {
        self.repository = repository
    }

    public func execute(userID: User.ID) async throws {
        try await repository.blockUser(userID: userID)
    }
}

