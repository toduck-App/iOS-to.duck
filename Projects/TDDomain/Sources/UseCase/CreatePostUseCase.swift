import Foundation

public protocol CreatePostUseCase {
    func execute(post: Post) async throws -> Bool
}

public final class CreatePostUseCaseImpl: CreatePostUseCase {
    private let repository: PostRepository
    
    public init(repository: PostRepository) {
        self.repository = repository
    }
    
    public func execute(post: Post) async throws -> Bool {
        return try await repository.createPost(post: post)
    }
}
