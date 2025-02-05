import TDCore

public protocol DeleteKeywordUseCase {
    func execute(keyword: Keyword) throws
    func execute()
}

public final class DeleteKeywordUseCaseImpl: DeleteKeywordUseCase {
    private let repository: RecentKeywordRepository

    public init(repository: RecentKeywordRepository) {
        self.repository = repository
    }

    public func execute(keyword: Keyword) throws {
        try repository.deleteRecentKeyword(keyword).get()
    }

    public func execute() {
        repository.deleteAllRecentKeywords()
    }
}
