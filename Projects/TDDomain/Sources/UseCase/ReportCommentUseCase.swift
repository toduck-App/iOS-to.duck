import Foundation

public protocol ReportCommentUseCase {
    func execute(comment: Comment) async throws -> Bool
}

public final class ReportCommentUseCaseImpl: ReportCommentUseCase {
    private let repository: CommentRepository
    
    public init(repository: CommentRepository) {
        self.repository = repository
    }
    
    public func execute(comment: Comment) async throws -> Bool {
        return try await repository.reportComment(commentId: comment.id)
    }
}
