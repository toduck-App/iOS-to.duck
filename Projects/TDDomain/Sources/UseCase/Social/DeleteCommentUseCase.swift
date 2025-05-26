import Foundation

public protocol DeleteCommentUseCase {
    func execute(postID: Post.ID, commentID: Comment.ID) async throws
}

public final class DeleteCommentUseCaseImpl: DeleteCommentUseCase {
    private let repository: SocialRepository
    
    public init(repository: SocialRepository) {
        self.repository = repository
    }
    
    public func execute(postID: Post.ID, commentID: Comment.ID) async throws {
        return try await repository.deleteComment(postID: postID, commentID: commentID)
    }
}
