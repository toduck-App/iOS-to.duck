//
//  CreatePostUseCase.swift
//  toduck
//
//  Created by 신효성 on 6/22/24.
//

import Foundation

public final class CreatePostUseCase {
    private let postRepository: PostRepositoryProtocol
    
    public init(postRepository: PostRepositoryProtocol) {
        self.postRepository = postRepository
    }
    
    public func execute(post: Post) async throws -> Bool {
        return try await postRepository.createPost(post: post)
    }
}