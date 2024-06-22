//
//  BlockPostUseCase.swift
//  toduck
//
//  Created by 신효성 on 6/22/24.
//

import Foundation

public final class BlockPostUseCase {
    private let repository: PostRepositoryProtocol
    
    public init(repository: PostRepositoryProtocol) {
        self.repository = repository
    }
    
    public func blockPost(post: Post) async throws -> Bool {
        return try await repository.blockPost(postId: post.id)
    }
}