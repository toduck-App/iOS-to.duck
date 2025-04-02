import Foundation

public protocol SearchPostUseCase {
    func execute(keyword: String, cursor: Int?, limit: Int, category: [PostCategory]?) async throws -> (result: [Post], hasMore: Bool, nextCursor: Int?)
}

public final class SearchPostUseCaseImpl: SearchPostUseCase {
    private let repository: PostRepository

    public init(repository: PostRepository) {
        self.repository = repository
    }

    public func execute(keyword: String, cursor: Int?, limit: Int, category: [PostCategory]?) async throws -> (result: [Post], hasMore: Bool, nextCursor: Int?) {
        try await repository.searchPost(keyword: keyword, cursor: cursor, limit: limit, category: category)
    }
}
