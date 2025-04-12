import Foundation
import TDData

public struct UserServiceImpl: UserService {
    private let provider: MFProvider<SocialAPI>

    public init(provider: MFProvider<SocialAPI> = MFProvider<SocialAPI>()) {
        self.provider = provider
    }
    
    public func requestUserBlock(userId: Int) async throws {
        try await provider.requestDecodable(of: EmptyResponse.self, .blockUser(userId: userId))
    }
    
    public func requestUserProfile(userId: Int) async throws -> TDUserProfileResponseDTO {
        let response = try await provider.requestDecodable(of: TDUserProfileResponseDTO.self, .fetchUser(userId: userId))
        return response.value
    }
    
    public func requestFollow(userId: Int) async throws {
        try await provider.requestDecodable(of: EmptyResponse.self, .followUser(targetUserId: userId))
    }
    
    public func requestUnfollow(userId: Int) async throws {
        try await provider.requestDecodable(of: EmptyResponse.self, .unfollowUser(targetUserId: userId))
    }
    
    public func requestUserPosts(userId: Int, cursor: Int?, limit: Int) async throws -> TDPostListDTO {
        let target = SocialAPI.fetchUserPostList(userId: userId, cursor: cursor, limit: limit)
        let response = try await provider.requestDecodable(of: TDPostListDTO.self, target)
        return response.value
    }
}
