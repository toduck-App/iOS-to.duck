//
//  ToggleUserFollowUserCase.swift
//  toduck
//
//  Created by 신효성 on 6/22/24.
//

import Foundation

public final class ToggleUserFollowUserCase {
    private let repostiory: UserRepository

    public init(repostiory: UserRepository) {
        self.repostiory = repostiory
    }

    public func execute(user: User, targetUser: User) async throws -> Bool {
        return try await repostiory.toggleUserFollow(userId: user.id, targetUserId: targetUser.id)
    }
}
