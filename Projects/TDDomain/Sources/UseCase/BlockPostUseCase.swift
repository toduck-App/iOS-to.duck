import Foundation

public protocol BlockPostUseCase {
    func execute(postID: Post.ID) async throws 
}

public final class BlockPostUseCaseImpl: BlockPostUseCase {
    private let repository: SocialRepository
    
    public init(repository: SocialRepository) {
        self.repository = repository
    }
    
    public func execute(postID: Post.ID) async throws {
        return try await repository.blockPost(postID: postID)
    }
}
