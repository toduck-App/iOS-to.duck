//
//  FetchUserRoutine.swift
//  toduck
//
//  Created by 신효성 on 6/22/24.
//

import Foundation

public final class FetchUserRoutineUseCase {
    private let repostiory: UserRepository

    public init(repostiory: UserRepository) {
        self.repostiory = repostiory
    }

    public func execute(user: User) async throws -> [Routine]? {
        return try await repostiory.fetchUserRoutineList(userId: user.id)
    }
}
