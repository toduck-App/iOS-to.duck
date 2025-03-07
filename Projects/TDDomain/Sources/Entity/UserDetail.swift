public struct UserDetail {
    public var isFollowing: Bool
    public let followingCount: Int
    public let followerCount: Int
    public let totalPostCount: Int
    public let totalRoutineCount: Int
    public let whoFollow: [User]?
    public let routineShareCount: Int
    
    public init(
        isFollowing: Bool,
        followingCount: Int,
        followerCount: Int,
        totalPostCount: Int,
        totalRoutineCount: Int,
        whoFollow: [User]? = nil,
        routineShareCount: Int
    ) {
        self.isFollowing = isFollowing
        self.followingCount = followingCount
        self.followerCount = followerCount
        self.totalPostCount = totalPostCount
        self.totalRoutineCount = totalRoutineCount
        self.whoFollow = whoFollow
        self.routineShareCount = routineShareCount
    }
}
