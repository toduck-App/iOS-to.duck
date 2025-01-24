import Foundation
import TDCore
import TDData

final class RecentKeywordStorageImpl: RecentKeywordStorage {
    private let userDefaults: UserDefaults
    private let key = "recentKeywords"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    /// UserDefaults에서 저장된 최근 검색어 목록을 가져옵니다.
    /// - Returns: [TDRecentKeywordDTO] 형태의 배열
    func fetchRecentKeywords() -> [TDData.TDRecentKeywordDTO] {
        guard let data = userDefaults.data(forKey: key),
              let decoded = try? JSONDecoder().decode([TDData.TDRecentKeywordDTO].self, from: data) else {
            return []
        }
        return decoded.sorted { $0.date > $1.date }
    }

    /// 새로운 검색어를 저장합니다.
    /// 동일 검색어가 이미 있으면 제거 후 최신 위치(배열의 0번 인덱스)에 추가하고,
    /// 전체 검색어가 10개를 초과하면 가장 오래된 검색어(마지막 인덱스)를 삭제합니다.
    /// - Parameter keyword: 저장할 검색어 DTO
    /// - Returns: 저장 성공/실패 Result
    func saveRecentKeyword(_ keyword: TDData.TDRecentKeywordDTO) -> Result<Void, TDCore.TDDataError> {
        var recentKeywords = fetchRecentKeywords()
        
        if let existingIndex = recentKeywords.firstIndex(where: { $0.keyword == keyword.keyword }) {
            recentKeywords.remove(at: existingIndex)
        }
        
        recentKeywords.insert(keyword, at: 0)
        
        if recentKeywords.count > 10 {
            recentKeywords.removeLast()
        }
        
        do {
            let encodedData = try JSONEncoder().encode(recentKeywords)
            userDefaults.set(encodedData, forKey: key)
            return .success(())
        } catch {
            return .failure(.convertDTOFailure)
        }
    }

    /// 특정 검색어를 삭제합니다.
    /// - Parameter keyword: 삭제할 검색어 DTO
    /// - Returns: 삭제 성공/실패 Result
    func deleteRecentKeyword(_ keyword: TDData.TDRecentKeywordDTO) -> Result<Void, TDCore.TDDataError> {
        var recentKeywords = fetchRecentKeywords()
        recentKeywords.removeAll { $0.keyword == keyword.keyword }
        
        do {
            let encodedData = try JSONEncoder().encode(recentKeywords)
            userDefaults.set(encodedData, forKey: key)
            return .success(())
        } catch {
            return .failure(.convertDTOFailure)
        }
    }

    /// 모든 최근 검색어를 삭제합니다.
    /// - Returns: 삭제 성공/실패 Result
    func deleteAllRecentKeywords() {
        userDefaults.removeObject(forKey: key)
    }
}
