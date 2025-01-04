import Foundation

public protocol ToggleUserFollowUseCase {
    func execute(userID: User.ID, targetUserID: User.ID) async throws -> Bool
}

public final class ToggleUserFollowUseCaseImpl: ToggleUserFollowUseCase {
    private let repository: UserRepository

    public init(repository: UserRepository) {
        self.repository = repository
    }

    public func execute(userID: User.ID, targetUserID: User.ID) async throws -> Bool {
        return try await repository.toggleUserFollow(userID: userID, targetUserID: targetUserID)
    }
}
