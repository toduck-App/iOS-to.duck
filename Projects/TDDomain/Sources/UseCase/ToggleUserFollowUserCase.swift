import Foundation

public protocol ToggleUserFollowUserCaseImpl {
    func toggleUserFollow(userId: Int, targetUserId: Int) async throws -> Bool
}

public final class ToggleUserFollowUserCase {
    private let repostiory: UserRepository

    public init(repostiory: UserRepository) {
        self.repostiory = repostiory
    }

    public func execute(user: User, targetUser: User) async throws -> Bool {
        return try await repostiory.toggleUserFollow(userId: user.id, targetUserId: targetUser.id)
    }
}
