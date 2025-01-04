import Foundation

public protocol ToggleUserFollowUseCase {
    func execute(userId: UUID, targetUserId: UUID) async throws -> Bool
}

public final class ToggleUserFollowUseCaseImpl: ToggleUserFollowUseCase {
    private let repository: UserRepository

    public init(repository: UserRepository) {
        self.repository = repository
    }

    public func execute(userId: UUID, targetUserId: UUID) async throws -> Bool {
        return try await repository.toggleUserFollow(userId: userId, targetUserId: targetUserId)
    }
}
