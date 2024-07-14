//
//  FetchPostUseCase.swift
//  toduck
//
//  Created by 신효성 on 6/22/24.
//

import Foundation

public final class FetchPostUseCase {
    private let repository: PostRepositoryProtocol
    
    public init(repository: PostRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(type: PostType, category: PostCategory) async throws -> [Post]? {
        return try await repository.fetchPostList(type: type, category: category)
    }
    public func excute(postId: Int) async throws -> Post? {
        return try await repository.fetchPost(postId: postId)
    }
}
