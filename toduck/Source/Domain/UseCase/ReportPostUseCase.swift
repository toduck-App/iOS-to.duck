//
//  ReportPostUseCase.swift
//  toduck
//
//  Created by 신효성 on 6/22/24.
//

import Foundation

public final class ReportPostUseCase {
    private let repository: PostRepositoryProtocol
    
    public init(repository: PostRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(post: Post) async throws -> Bool {
        return try await repository.reportPost(postId: post.id)
    }
}