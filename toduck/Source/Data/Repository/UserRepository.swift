//
//  UserRepository.swift
//  toduck
//
//  Created by 신효성 on 6/13/24.
//

import Foundation

public final class UserRepository: UserRepositoryProtocol {
    private let dummyUser = User(id: "", name: "", icon: "", title: "", isblock: false)

    public init() {}

    public func fetchUser(userId: String) async throws -> User? {
        return dummyUser
    }

    public func fetchUserDetail(userId: String) async throws -> UserDetail {
        return UserDetail(isFollowing: false, follwingCount: 0, followerCount: 0, totalPostNReply: 0, profileURL: "String", whofollow: [], routines: [], routineShareCount: 0, posts: [])
    }

    public func fetchUserPostList(userId: String) async throws -> [Post]? {
        return []
    }

    public func fetchUserRoutineList(userId: String) async throws -> [Routine]? {
        return []
    }

    public func fetchUserShareUrl(userId: String) async throws -> String {
        return ""
    }

    public func toggleUserFollow(userId: String, targetUserId: String) async throws -> Bool {
        return false
    }


}