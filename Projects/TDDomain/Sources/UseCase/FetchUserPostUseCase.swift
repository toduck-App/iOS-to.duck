//
//  FetchUserPostUseCase.swift
//  toduck
//
//  Created by 신효성 on 6/22/24.
//

import Foundation

public protocol FetchUserPostUseCase {
    func execute(id: User.ID) async throws -> [Post]?
}

public final class FetchUserPostUseCaseImpl: FetchUserPostUseCase {
    private let repostiory: UserRepository

    public init(repository: UserRepository) {
        self.repostiory = repository
    }

    public func execute(id: User.ID) async throws -> [Post]? {
        return try await repostiory.fetchUserPostList(userId: id)
    }
}
