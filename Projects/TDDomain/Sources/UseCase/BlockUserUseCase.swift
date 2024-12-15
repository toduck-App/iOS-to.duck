import Foundation

public protocol BlockUserUseCase {
    func execute(user: User) async throws -> Bool
}

public final class BlockUserUseCaseImpl: BlockUserUseCase {
    private let repository: UserRepository

    public init(repository: UserRepository) {
        self.repository = repository
    }

    public func execute(user: User) async throws -> Bool {
        try await repository.blockUser(userId: user.id)
    }
}
