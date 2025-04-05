import Foundation

public protocol CreatePostUseCase {
    func execute(post: Post, image: [(fileName: String, imageData: Data)]?) async throws
}

public final class CreatePostUseCaseImpl: CreatePostUseCase {
    private let repository: SocialRepository
    
    public init(repository: SocialRepository) {
        self.repository = repository
    }
    
    public func execute(post: Post, image: [(fileName: String, imageData: Data)]?) async throws {
        return try await repository.createPost(post: post, image: image)
    }
}
