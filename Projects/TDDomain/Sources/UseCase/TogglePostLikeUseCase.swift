import Foundation

public protocol TogglePostLikeUseCase {
    func execute(postID: Post.ID, currentLike: Bool) async throws
}

public final class TogglePostLikeUseCaseImpl: TogglePostLikeUseCase {
    private let repository: PostRepository
    
    public init(repository: PostRepository) {
        self.repository = repository
    }
    
    public func execute(postID: Post.ID, currentLike: Bool) async throws {
        try await repository.togglePostLike(postID: postID, currentLike: currentLike)
    }
}   
