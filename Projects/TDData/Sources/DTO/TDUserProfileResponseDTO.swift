public struct TDUserProfileResponseDTO: Decodable {
    let nickname: String
    let profileImageUrl: String?
    let followingCount: Int
    let followerCount: Int
    let postCount: Int
    let isMe: Bool
}
