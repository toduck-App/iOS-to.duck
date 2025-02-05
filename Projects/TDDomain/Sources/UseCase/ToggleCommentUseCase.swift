import Foundation

public protocol ToggleCommentLikeUseCase {
    func execute(commentID: Comment.ID) async throws -> Comment
}

public final class ToggleCommentLikeUseCaseImpl: ToggleCommentLikeUseCase {
    private let repository: CommentRepository
    
    public init(repository: CommentRepository) {
        self.repository = repository
    }
    
    public func execute(commentID: Comment.ID) async throws -> Comment {
        return try await repository.toggleCommentLike(commentID: commentID).get()
    }
}
