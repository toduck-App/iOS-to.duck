import Foundation

public protocol CreateCommentUseCase {
    func execute(postID: Post.ID, parentId: Comment.ID?, content: String, image: (fileName: String, imageData: Data)?) async throws -> Comment.ID
}

public final class CreateCommentUseCaseImpl: CreateCommentUseCase {
    
    private let repository: SocialRepository
    
    public init(repository: SocialRepository) {
        self.repository = repository
    }
    
    public func execute(postID: Post.ID, parentId: Comment.ID?, content: String, image: (fileName: String, imageData: Data)?) async throws -> Comment.ID {
        return try await repository.createComment(postID: postID, parentId: parentId, content: content, image: image)
    }
}
