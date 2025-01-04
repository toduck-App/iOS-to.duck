import Foundation

public protocol TogglePostLikeUseCase {
    func execute(postID: Post.ID) async throws -> Bool
}

public final class TogglePostLikeUseCaseImpl: TogglePostLikeUseCase {
    private let repository: PostRepository
    
    public init(repository: PostRepository) {
        self.repository = repository
    }
    
    public func execute(postID: Post.ID) async throws -> Bool {
        try await repository.togglePostLike(postID: postID)
    }
}   
