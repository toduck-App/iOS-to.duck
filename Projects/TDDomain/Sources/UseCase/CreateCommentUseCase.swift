import Foundation

public protocol CreateCommentUseCase {
    func execute(newComment: NewComment) async throws -> Bool
}

public final class CreateCommentUseCaseImpl: CreateCommentUseCase {
    
    private let repository: CommentRepository
    
    public init(repository: CommentRepository) {
        self.repository = repository
    }
    
    public func execute(newComment: NewComment) async throws -> Bool {
        return try await repository.createComment(comment: newComment)
    }
}
