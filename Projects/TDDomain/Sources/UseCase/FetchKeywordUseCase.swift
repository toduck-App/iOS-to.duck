import TDCore

public protocol FetchKeywordUseCase {
    func execute() -> [Keyword]
}

public final class FetchKeywordUseCaseImpl: FetchKeywordUseCase {
    private let repository: RecentKeywordRepository

    public init(repository: RecentKeywordRepository) {
        self.repository = repository
    }

    public func execute() -> [Keyword] {
        repository.fetchRecentKeywords()
    }
}
