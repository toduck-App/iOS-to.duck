import Foundation

public protocol BlockPostUseCase {
    func execute(postID: Post.ID) async throws -> Bool
}

public final class BlockPostUseCaseImpl: BlockPostUseCase {
    private let repository: PostRepository
    
    public init(repository: PostRepository) {
        self.repository = repository
    }
    
    public func execute(postID: Post.ID) async throws -> Bool {
        return try await repository.blockPost(postID: postID)
    }
}
