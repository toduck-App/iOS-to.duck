import Foundation
import TDDomain

public final class UserRepositoryImpl: UserRepository {
    private let dummyUserDetail = UserDetail(
        isFollowing: false,
        followingCount: 12,
        followerCount: 261,
        totalPostCount: 1,
        whofollow: [],
        routineShareCount: 1
    )

    public init() {}

    public func fetchUser(userId: Int) async throws -> User {
        User.dummy.filter { $0.id == userId }.first!
    }

    public func fetchUserDetail(userId: Int) async throws -> UserDetail {
        dummyUserDetail
    }

    public func fetchUserPostList(userId: Int) async throws -> [Post]? {
        Post.dummy.filter { $0.user.id == userId }
    }

    public func fetchUserRoutineList(userId: Int) async throws -> [Routine]? {
        []
    }

    public func fetchUserShareUrl(userId: Int) async throws -> String {
        ""
    }

    public func toggleUserFollow(userId: Int, targetUserId: Int) async throws -> Bool {
        false
    }

    public func blockUser(userId: Int) async throws -> Bool {
        true
    }
}
