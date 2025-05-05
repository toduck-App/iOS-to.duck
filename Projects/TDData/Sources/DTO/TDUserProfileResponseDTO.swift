public struct TDUserProfileResponseDTO: Decodable {
    let nickname: String
    let profileImageUrl: String?
    let followingCount: Int
    let followerCount: Int
    let postCount: Int
    let totalCommentCount: Int
    let totalRoutineShareCount: Int
    let isMe: Bool
    let isFollowing: Bool
}
