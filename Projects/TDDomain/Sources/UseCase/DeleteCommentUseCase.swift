import Foundation

public protocol DeleteCommentUseCase {
    func execute(comment: Comment) async throws -> Bool
}

public final class DeleteCommentUseCaseImpl: DeleteCommentUseCase {
    private let repository: CommentRepository
    
    public init(repository: CommentRepository) {
        self.repository = repository
    }
    
    public func execute(comment: Comment) async throws -> Bool {
        return try await repository.deleteComment(commentId: comment.id)
    }
}
