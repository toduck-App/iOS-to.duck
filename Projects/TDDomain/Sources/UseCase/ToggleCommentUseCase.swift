import Foundation

public protocol ToggleCommentLikeUseCase {
    func execute(commentID: Comment.ID) async throws -> Comment
}

public final class ToggleCommentLikeUseCaseImpl: ToggleCommentLikeUseCase {
    private let repository: SocialRepository
    
    public init(repository: SocialRepository) {
        self.repository = repository
    }
    
    public func execute(commentID: Comment.ID) async throws -> Comment {
        return try await repository.toggleCommentLike(commentID: commentID).get()
    }
}
