//
//  SearchPostUseCase.swift
//  toduck
//
//  Created by 신효성 on 6/22/24.
//

import Foundation

public final class SearchPostUseCase {
    private let repository: PostRepository

    public init(repository: PostRepository) {
        self.repository = repository
    }

    public func execute(keyword: String, category: PostCategory) async throws -> [Post]? {
        try await repository.searchPost(keyword: keyword, category: category)
    }
}
