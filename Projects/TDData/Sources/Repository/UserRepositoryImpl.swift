import Foundation
import TDDomain

public final class UserRepositoryImpl: UserRepository {
    private let service: UserService

    public init(service: UserService) {
        self.service = service
    }

    public func fetchUser(userID: User.ID) async throws -> User {
        User.dummy.first!
    }

    public func fetchUserDetail(userID: User.ID) async throws -> UserDetail {
        UserDetail.dummyUserDetail
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
        UserDetail.dummyUserDetail.isFollowing.toggle()
        return UserDetail.dummyUserDetail.isFollowing
    }

    public func blockUser(userID: User.ID) async throws {
        try await service.requestUserBlock(userId: userID)
    }
}
