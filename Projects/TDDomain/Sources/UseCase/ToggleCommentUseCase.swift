import Foundation

public protocol ToggleCommentUseCase {
    func execute(commentID: Comment.ID) async throws -> Bool
}

public final class ToggleCommentUseCaseImpl: ToggleCommentUseCase {
    private let repository: CommentRepository
    
    public init(repository: CommentRepository) {
        self.repository = repository
    }
    
    public func execute(commentID: Comment.ID) async throws -> Bool {
        return try await repository.toggleCommentLike(commentID: commentID)
    }
}
