import Foundation

public protocol UpdatePostUseCase{
    func execute(prevPost: Post, updatePost: Post, image: [(fileName: String, imageData: Data)]?) async throws
}
public final class UpdatePostUseCaseImpl: UpdatePostUseCase {
    private let repository: SocialRepository
    
    public init(repository: SocialRepository) {
        self.repository = repository
    }
    
    public func execute(prevPost: Post, updatePost: Post, image: [(fileName: String, imageData: Data)]?) async throws  {
        return try await repository.updatePost(prevPost: prevPost, updatePost: updatePost, image: image)
    }
}
