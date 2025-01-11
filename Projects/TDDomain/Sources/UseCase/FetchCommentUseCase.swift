import Foundation

public protocol FetchCommentUseCase {
    func execute(postID: Post.ID) async throws -> [Comment]?
    func execute(commentID: Comment.ID) async throws -> [Comment]?
    func execute(userID: User.ID) async throws -> [Comment]?
}

public final class FetchCommentUseCaseImpl: FetchCommentUseCase {
    private let repository: CommentRepository
    
    public init(repository: CommentRepository) {
        self.repository = repository
    }
    
    public func execute(postID: Post.ID) async throws -> [Comment]? {
        return try await repository.fetchCommentList(postID: postID)
    }
    
    public func execute(commentID: Comment.ID) async throws -> [Comment]? {
        return try await repository.fetchCommentList(commentID: commentID)
    }
    public func execute(userID: User.ID) async throws -> [Comment]? {
        return try await repository.fetchUserCommentList(userID: userID)
    }
}
