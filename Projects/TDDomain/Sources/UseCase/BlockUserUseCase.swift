import Foundation

public protocol BlockUserUseCase {
    func execute(userID: User.ID) async throws -> Bool
}

public final class BlockUserUseCaseImpl: BlockUserUseCase {
    private let repository: UserRepository

    public init(repository: UserRepository) {
        self.repository = repository
    }

    public func execute(userID: User.ID) async throws -> Bool {
        try await repository.blockUser(userID: userID)
    }
}
