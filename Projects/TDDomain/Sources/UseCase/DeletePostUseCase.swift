import Foundation

public protocol DeletePostUseCase {
    func execute(postID: Post.ID) async throws -> Bool
}

public final class DeletePostUseCaseImpl: DeletePostUseCase {
    private let repository: PostRepository
    
    public init(repository: PostRepository) {
        self.repository = repository
    }
    
    public func execute(postID: Post.ID) async throws -> Bool {
        return try await repository.deletePost(postID: postID)
    }
}
