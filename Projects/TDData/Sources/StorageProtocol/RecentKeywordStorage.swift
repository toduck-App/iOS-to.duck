import TDCore

public protocol RecentKeywordStorage {
    func fetchRecentKeywords() -> [TDRecentKeywordDTO]
    func saveRecentKeyword(_ keyword: TDRecentKeywordDTO) -> Result<Void, TDCore.TDDataError>
    func deleteRecentKeyword(_ keyword: TDRecentKeywordDTO) -> Result<Void, TDCore.TDDataError>
    func deleteAllRecentKeywords()
}
