import Foundation

public protocol BlockCommentUseCase {
    func execute(commentID: Comment.ID) async throws -> Bool
}

public final class BlockCommentUseCaseImpl: BlockCommentUseCase {
    private let repository: SocialRepository
    
    public init(repository: SocialRepository) {
        self.repository = repository
    }
    
    public func execute(commentID: Comment.ID) async throws -> Bool {
        return try await repository.blockComment(commentID: commentID)
    }
}
