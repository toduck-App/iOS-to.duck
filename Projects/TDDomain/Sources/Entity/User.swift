//
//  User.swift
//  toduck
//
//  Created by 신효성 on 6/13/24.
//

import Foundation

public struct User: Identifiable {
    public let id: Int
    public let name: String
    public let icon: String?
    public let title: String
    public let isblock: Bool
    
    public init(
        id: Int,
        name: String,
        icon: String?,
        title: String,
        isblock: Bool
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.title = title
        self.isblock = isblock
    }
}

public struct UserDetail {
    public let isFollowing: Bool
    public let followingCount: Int
    public let followerCount: Int
    public let totalPostCount: Int
    public let whofollow: [String]?
    public let routineShareCount: Int
    
    public init(
        isFollowing: Bool,
        followingCount: Int,
        followerCount: Int,
        totalPostCount: Int,
        whofollow: [String]? = nil,
        routineShareCount: Int
    ) {
        self.isFollowing = isFollowing
        self.followingCount = followingCount
        self.followerCount = followerCount
        self.totalPostCount = totalPostCount
        self.whofollow = whofollow
        self.routineShareCount = routineShareCount
    }
}

public extension User {
    static let dummy: [User] = [
        .init(id: 1, name: "오리발", icon: "https://avatars.githubusercontent.com/u/46300191?v=4", title: "작심삼일", isblock: false),
        .init(id: 2, name: "꽉꽉", icon: "https://avatars.githubusercontent.com/u/129862357?v=4", title: "작심삼일", isblock: false),
        .init(id: 3, name: "오리궁뎅이", icon: "https://avatars.githubusercontent.com/u/57449485?v=4", title: "작심삼일", isblock: false),
        .init(id: 76, name: "꽉꽉", icon: nil, title: "작심삼일", isblock: false),
        .init(id: 33, name: "오리궁뎅이", icon: nil, title: "작심삼일", isblock: false),
    ]
}
