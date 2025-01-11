public struct UserDetail {
    public let isFollowing: Bool
    public let followingCount: Int
    public let followerCount: Int
    public let totalPostCount: Int
    public let whoFollow: [User]?
    public let routineShareCount: Int
    
    public init(
        isFollowing: Bool,
        followingCount: Int,
        followerCount: Int,
        totalPostCount: Int,
        whoFollow: [User]? = nil,
        routineShareCount: Int
    ) {
        self.isFollowing = isFollowing
        self.followingCount = followingCount
        self.followerCount = followerCount
        self.totalPostCount = totalPostCount
        self.whoFollow = whoFollow
        self.routineShareCount = routineShareCount
    }
}
