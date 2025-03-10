import Foundation
import TDDomain

public final class UserRepositoryImpl: UserRepository {
    private var dummyUserDetail = UserDetail(
        isFollowing: true,
        followingCount: 12,
        followerCount: 261,
        totalPostCount: 1,
        totalRoutineCount: 1,
        whoFollow: [],
        routineShareCount: 1
    )

    public init() {}

    public func fetchUser(userID: User.ID) async throws -> User {
        User.dummy.first!
    }

    public func fetchUserDetail(userID: User.ID) async throws -> UserDetail {
        dummyUserDetail
    }

    public func fetchUserPostList(userID: User.ID) async throws -> [Post]? {
        Post.dummy.filter { $0.user.id == userID }
    }

    public func fetchUserRoutineList(userID: User.ID) async throws -> [Routine]? {
        Routine.dummy
    }

    public func fetchUserShareUrl(userID: User.ID) async throws -> String {
        ""
    }

    public func toggleUserFollow(userID: User.ID, targetUserID: User.ID) async throws -> Bool {
        dummyUserDetail.isFollowing.toggle()
        return dummyUserDetail.isFollowing
    }

    public func blockUser(userID: User.ID) async throws -> Bool {
        true
    }
}
