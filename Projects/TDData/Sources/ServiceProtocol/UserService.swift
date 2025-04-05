
public protocol UserService {
    func requestUserBlock(userId: Int) async throws
    func requestUserProfile(userId: Int) async throws -> TDUserProfileResponseDTO
}
