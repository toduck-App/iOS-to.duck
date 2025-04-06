
public protocol UserService {
    func requestUserBlock(userId: Int) async throws
    func requestUserProfile(userId: Int) async throws -> TDUserProfileResponseDTO
    func requestFollow(userId: Int) async throws
    func requestUnfollow(userId: Int) async throws
}
