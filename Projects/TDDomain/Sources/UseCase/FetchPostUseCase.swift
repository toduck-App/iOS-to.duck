import Foundation

public protocol FetchPostUseCase {
    func execute(cursor: Int?, limit: Int, category: [PostCategory]?) async throws -> (result: [Post], hasMore: Bool, nextCursor: Int?)
    func execute(postID: Post.ID) async throws -> Post?
}

public final class FetchPostUseCaseImpl: FetchPostUseCase {
    private let repository: PostRepository
    
    public init(repository: PostRepository) {
        self.repository = repository
    }
    
    public func execute(cursor: Int?, limit: Int, category: [PostCategory]?) async throws -> (result: [Post], hasMore: Bool, nextCursor: Int?) {
        return try await repository.fetchPostList(cursor: cursor, limit: limit, category: category)
    }
    
    public func execute(postID: Post.ID) async throws -> Post? {
        return try await repository.fetchPost(postID: postID)
    }
}
