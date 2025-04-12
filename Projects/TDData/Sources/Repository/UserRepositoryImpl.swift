import Foundation
import TDDomain

public final class UserRepositoryImpl: UserRepository {
    private let service: UserService

    public init(service: UserService) {
        self.service = service
    }

    public func fetchUser(userID: User.ID) async throws -> (User, UserDetail) {
        let dto = try await service.requestUserProfile(userId: userID)
        let user = User(id: userID, name: dto.nickname, icon: dto.profileImageUrl, title: "작심삼일")
        let userDetail = UserDetail(isFollowing: dto.isFollowing, followingCount: dto.followingCount, followerCount: dto.followerCount, totalPostCount: dto.postCount, totalRoutineCount: dto.totalRoutineShareCount, isMe: dto.isMe)
        return (user, userDetail)
    }

    public func fetchUserPostList(userID: User.ID, cursor: Int?, limit: Int) async throws -> (result: [Post], hasMore: Bool, nextCursor: Int?) {
        let postListDTO = try await service.requestUserPosts(userId: userID, cursor: cursor, limit: limit)
        let postList = postListDTO.results.compactMap { $0.convertToPost() }
        
        return (postList, postListDTO.hasMore, postListDTO.nextCursor)
    }

    public func fetchUserRoutineList(userID: User.ID) async throws -> [Routine]? {
        Routine.dummy
    }

    public func fetchUserShareUrl(userID: User.ID) async throws -> String {
        ""
    }

    public func followUser(targetUserID: TDDomain.User.ID) async throws {
        try await service.requestFollow(userId: targetUserID)
    }
    
    public func unFollowUser(targetUserID: TDDomain.User.ID) async throws {
        try await service.requestUnfollow(userId: targetUserID)
    }

    public func blockUser(userID: User.ID) async throws {
        try await service.requestUserBlock(userId: userID)
    }
}
