import Foundation

public protocol SearchPostUseCase {
    func execute(keyword: String, cursor: Int?, limit: Int, category: [PostCategory]?) async throws
}

public final class SearchPostUseCaseImpl: SearchPostUseCase {
    private let repository: SocialRepository
    
    public init(repository: SocialRepository) {
        self.repository = repository
    }

    public func execute(keyword: String, cursor: Int?, limit: Int, category: [PostCategory]?) async throws {
        repository.setModeSearch(keyword)
        return try await repository.searchPost(keyword: keyword, cursor: cursor, limit: limit, category: category)
    }
}
