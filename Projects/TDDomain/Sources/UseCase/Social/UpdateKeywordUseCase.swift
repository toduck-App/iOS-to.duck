import TDCore

public protocol UpdateKeywordUseCase {
    func execute(keyword: Keyword) throws
}

public final class UpdateKeywordUseCaseImpl: UpdateKeywordUseCase {
    private let repository: RecentKeywordRepository

    public init(repository: RecentKeywordRepository) {
        self.repository = repository
    }

    public func execute(keyword: Keyword) throws {
        try repository.saveRecentKeyword(keyword).get()
    }
}
