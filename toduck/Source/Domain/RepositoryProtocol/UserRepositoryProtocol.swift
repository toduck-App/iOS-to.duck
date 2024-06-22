//
//  UserRepositoryProtocol.swift
//  toduck
//
//  Created by 신효성 on 6/13/24.
//

import Foundation

public protocol UserRepositoryProtocol {
    func fetchUser(userId: String) async throws -> User?
    func fetchUserDetail(userId: String) async throws -> UserDetail
    func fetchUserPostList(userId: String) async throws -> [Post]?
    func fetchUserRoutineList(userId: String) async throws -> [Routine]?
    func fetchUserShareUrl(userId: String) async throws -> String
    func toggleUserFollow(userId: String,targetUserId: String) async throws -> Bool
}
