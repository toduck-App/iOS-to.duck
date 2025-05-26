import TDCore

public protocol RecentKeywordRepository {
    func fetchRecentKeywords() -> [Keyword]
    func saveRecentKeyword(_ keyword: Keyword) -> Result<Void, TDCore.TDDataError>
    func deleteRecentKeyword(_ keyword: Keyword) -> Result<Void, TDCore.TDDataError>
    func deleteAllRecentKeywords()
}
