import Foundation

public protocol FetchCommentUseCase {
    func execute(postID: Int) async throws -> [Comment]?
    func execute(comment: Comment) async throws -> [Comment]?
    func execute(user: User) async throws -> [Comment]?
}

public final class FetchCommentUseCaseImpl: FetchCommentUseCase {
    private let repository: CommentRepository
    
    public init(repository: CommentRepository) {
        self.repository = repository
    }
    
    public func execute(postID: Int) async throws -> [Comment]? {
        return try await repository.fetchCommentList(postId: postID)
    }
    
    public func execute(comment: Comment) async throws -> [Comment]? {
        return try await repository.fetchCommentList(commentId: comment.id)
    }
    public func execute(user: User) async throws -> [Comment]? {
        return try await repository.fetchUserCommentList(userId: user.id)
    }
}
