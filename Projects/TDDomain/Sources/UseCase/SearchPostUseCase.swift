import Foundation

public protocol SearchPostUseCase {
    func execute(keyword: String) async throws -> [Post]?
}

public final class SearchPostUseCaseImpl: SearchPostUseCase {
    private let repository: PostRepository

    public init(repository: PostRepository) {
        self.repository = repository
    }

    public func execute(keyword: String) async throws -> [Post]? {
        try await repository.searchPost(keyword: keyword)
    }
}
