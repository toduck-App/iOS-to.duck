import Foundation

public protocol ToggleUserFollowUseCase {
    func execute(userId: Int, targetUserId: Int) async throws -> Bool
}

public final class ToggleUserFollowUseCaseImpl: ToggleUserFollowUseCase {
    private let repository: UserRepository

    public init(repository: UserRepository) {
        self.repository = repository
    }

    public func execute(userId: Int, targetUserId: Int) async throws -> Bool {
        return try await repository.toggleUserFollow(userId: userId, targetUserId: targetUserId)
    }
}
