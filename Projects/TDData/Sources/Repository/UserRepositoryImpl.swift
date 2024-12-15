import Foundation
import TDDomain

public final class UserRepositoryImpl: UserRepository {
    private let dummyUser = User(id: 0, name: "", icon: "", title: "", isblock: false)

    public init() {}

    public func fetchUser(userId: Int) async throws -> User? {
        dummyUser
    }

    public func fetchUserDetail(userId: Int) async throws -> UserDetail {
        UserDetail(
            isFollowing: false,
            follwingCount: 0,
            followerCount: 0,
            totalPostNReply: 0,
            profileURL: "String",
            whofollow: [],
            routines: [],
            routineShareCount: 0,
            posts: []
        )
    }

    public func fetchUserPostList(userId: Int) async throws -> [Post]? {
        []
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
