import Foundation

public protocol FetchPostUseCase {
    func execute(cursor: Int?, limit: Int, category: [PostCategory]?) async throws
}

public final class FetchPostUseCaseImpl: FetchPostUseCase {
    private let repository: SocialRepository
    public init(repository: SocialRepository) {
        self.repository = repository
    }

    public func execute(cursor: Int?, limit: Int, category: [PostCategory]?) async throws {
        repository.setModeDefault()
        return try await repository.fetchPostList(cursor: cursor, limit: limit, category: category)
    }
}

