import Foundation

public protocol UpdatePostUseCase{
    func execute(post: Post) async throws
}

public final class UpdatePostUseCaseImpl: UpdatePostUseCase {
    private let repository: SocialRepository
    
    public init(repository: SocialRepository) {
        self.repository = repository
    }
    
    public func execute(post: Post) async throws  {
        return try await repository.updatePost(post: post)
    }
}
