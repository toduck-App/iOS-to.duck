import Foundation

public protocol TogglePostLikeUseCase {
    func execute(postID: Post.ID) async throws -> Post
}

public final class TogglePostLikeUseCaseImpl: TogglePostLikeUseCase {
    private let repository: PostRepository
    
    public init(repository: PostRepository) {
        self.repository = repository
    }
    
    public func execute(postID: Post.ID) async throws -> Post {
        try await repository.togglePostLike(postID: postID).get()
    }
}   
