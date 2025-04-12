import Foundation

public protocol ToggleCommentLikeUseCase {
    func execute(postID: Post.ID, commentID: Comment.ID, currentLike: Bool) async throws
}

public final class ToggleCommentLikeUseCaseImpl: ToggleCommentLikeUseCase {
    private let repository: SocialRepository
    
    public init(repository: SocialRepository) {
        self.repository = repository
    }
    
    public func execute(postID: Post.ID, commentID: Comment.ID, currentLike: Bool) async throws {
        try await repository.toggleCommentLike(postID: postID, commentID: commentID, currentLike: currentLike)
    }
}
