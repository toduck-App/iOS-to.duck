import Foundation

public protocol UpdatePostUseCase{
    func execute(post: Post) async throws -> Bool
}

public final class UpdatePostUseCaseImpl: UpdatePostUseCase {
    private let repository: PostRepository
    
    public init(repository: PostRepository) {
        self.repository = repository
    }
    
    public func execute(post: Post) async throws -> Bool {
        return try await repository.createPost(post: post)
    }
}
