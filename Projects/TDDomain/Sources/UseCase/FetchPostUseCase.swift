import Foundation

public protocol FetchPostUseCase {
    func execute(category: PostCategory?) async throws -> [Post]?
    func execute(postId: Int) async throws -> Post?
}

public final class FetchPostUseCaseImpl: FetchPostUseCase {
    private let repository: PostRepository
    
    public init(repository: PostRepository) {
        self.repository = repository
    }
    
    public func execute(category: PostCategory?) async throws -> [Post]? {
        return try await repository.fetchPostList(category: category)
    }
    
    public func execute(postId: Int) async throws -> Post? {
        return try await repository.fetchPost(postId: postId)
    }
}
