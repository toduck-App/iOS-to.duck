import Foundation

public protocol DeletePostUseCase {
    func execute(postID: Post.ID) async throws
}

public final class DeletePostUseCaseImpl: DeletePostUseCase {
    private let repository: SocialRepository
    
    public init(repository: SocialRepository) {
        self.repository = repository
    }
    
    public func execute(postID: Post.ID) async throws {
        return try await repository.deletePost(postID: postID)
    }
}
