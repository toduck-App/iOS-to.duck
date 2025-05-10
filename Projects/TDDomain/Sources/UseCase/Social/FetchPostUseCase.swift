import Foundation

public protocol FetchPostUseCase {
    func execute(cursor: Int?, limit: Int, category: [PostCategory]?) async throws -> (result: [Post], hasMore: Bool, nextCursor: Int?)
    func execute(postID: Post.ID) async throws -> (post: Post, comments: [Comment])
}

public final class FetchPostUseCaseImpl: FetchPostUseCase {
    private let repository: SocialRepository
    
    public init(repository: SocialRepository) {
        self.repository = repository
    }
    
    public func execute(cursor: Int?, limit: Int, category: [PostCategory]?) async throws -> (result: [Post], hasMore: Bool, nextCursor: Int?) {
        return try await repository.fetchPostList(cursor: cursor, limit: limit, category: category)
    }
    
    public func execute(postID: Post.ID) async throws -> (post: Post, comments: [Comment]) {
        return try await repository.fetchPost(postID: postID)
    }
}
