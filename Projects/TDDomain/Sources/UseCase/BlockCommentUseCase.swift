import Foundation

public protocol BlockCommentUseCase {
    func execute(comment: Comment) async throws -> Bool
}

public final class BlockCommentUseCaseImpl: BlockCommentUseCase {
    private let repository: CommentRepository
    
    public init(repository: CommentRepository) {
        self.repository = repository
    }
    
    public func execute(comment: Comment) async throws -> Bool {
        return try await repository.blockComment(commentId: comment.id)
    }
}
