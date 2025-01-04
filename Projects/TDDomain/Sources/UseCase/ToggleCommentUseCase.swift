import Foundation

public protocol ToggleCommentUseCase {
    func execute(comment: Comment) async throws -> Bool
}

public final class ToggleCommentUseCaseImpl: ToggleCommentUseCase {
    private let repository: CommentRepository
    
    public init(repository: CommentRepository) {
        self.repository = repository
    }
    
    public func execute(comment: Comment) async throws -> Bool {
        return try await repository.toggleCommentLike(commentId: comment.id)
    }
}
