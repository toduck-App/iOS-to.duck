import TDCore
import TDDomain

public final class RecentKeywordRepositoryImpl: RecentKeywordRepository {
    private let storage: RecentKeywordStorage
    
    public init(storage: RecentKeywordStorage) {
        self.storage = storage
    }
    
    public func fetchRecentKeywords() -> [TDDomain.Keyword] {
        storage.fetchRecentKeywords().map { $0.convertToTDRecentKeywordDTO() }
    }
    
    public func saveRecentKeyword(_ keyword: TDDomain.Keyword) -> Result<Void, TDCore.TDDataError> {
        storage.saveRecentKeyword(TDRecentKeywordDTO(date: keyword.date, keyword: keyword.word))
    }
    
    public func deleteRecentKeyword(_ keyword: TDDomain.Keyword) -> Result<Void, TDCore.TDDataError> {
        storage.deleteRecentKeyword(TDRecentKeywordDTO(date: keyword.date, keyword: keyword.word))
    }
    
    public func deleteAllRecentKeywords() {
        storage.deleteAllRecentKeywords()
    }
}
