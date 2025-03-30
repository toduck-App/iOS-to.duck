import Foundation

public protocol CreatePostUseCase {
    func execute(post: Post, image: [(fileName: String, imageData: Data)]?) async throws
}

public final class CreatePostUseCaseImpl: CreatePostUseCase {
    private let repository: PostRepository
    
    public init(repository: PostRepository) {
        self.repository = repository
    }
    
    public func execute(post: Post, image: [(fileName: String, imageData: Data)]?) async throws {
        return try await repository.createPost(post: post, image: image)
    }
}
