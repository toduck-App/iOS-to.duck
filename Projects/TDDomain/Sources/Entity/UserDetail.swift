public struct UserDetail {
    public var isFollowing: Bool
    public let followingCount: Int
    public let followerCount: Int
    public let totalPostCount: Int
    public let totalRoutineCount: Int
    public let isMe: Bool
    
    public init(
        isFollowing: Bool,
        followingCount: Int,
        followerCount: Int,
        totalPostCount: Int,
        totalRoutineCount: Int,
        isMe: Bool
    ) {
        self.isFollowing = isFollowing
        self.followingCount = followingCount
        self.followerCount = followerCount
        self.totalPostCount = totalPostCount
        self.totalRoutineCount = totalRoutineCount
        self.isMe = isMe
    }
}

extension UserDetail {
    public static var dummyUserDetail = UserDetail(
        isFollowing: true,
        followingCount: 12,
        followerCount: 261,
        totalPostCount: 1,
        totalRoutineCount: 1,
        isMe: false
    )
}
