public struct UserDetail {
    public var isFollowing: Bool
    public let followingCount: Int
    public var followerCount: Int
    public let totalPostCount: Int
    public let totalCommentCount: Int
    public let totalRoutineCount: Int
    public let isMe: Bool

    public init(
        isFollowing: Bool,
        followingCount: Int,
        followerCount: Int,
        totalPostCount: Int,
        totalCommentCount: Int,
        totalRoutineCount: Int,
        isMe: Bool
    ) {
        self.isFollowing = isFollowing
        self.followingCount = followingCount
        self.followerCount = followerCount
        self.totalPostCount = totalPostCount
        self.totalCommentCount = totalCommentCount
        self.totalRoutineCount = totalRoutineCount
        self.isMe = isMe
    }
}

public extension UserDetail {
    static var dummyUserDetail = UserDetail(
        isFollowing: true,
        followingCount: 12,
        followerCount: 261,
        totalPostCount: 1,
        totalCommentCount: 1,
        totalRoutineCount: 1,
        isMe: false
    )
}
