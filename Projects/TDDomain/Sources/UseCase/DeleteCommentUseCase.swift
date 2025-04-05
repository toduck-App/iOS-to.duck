import Foundation

public protocol DeleteCommentUseCase {
    func execute(commentID: Comment.ID) async throws -> Bool
}

public final class DeleteCommentUseCaseImpl: DeleteCommentUseCase {
    private let repository: SocialRepository
    
    public init(repository: SocialRepository) {
        self.repository = repository
    }
    
    public func execute(commentID: Comment.ID) async throws -> Bool {
        return try await repository.deleteComment(commentID: commentID)
    }
}
