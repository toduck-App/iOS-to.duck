import Foundation
import TDCore

enum TDDiaryUtils {
    /// 데이터 Fetch 요청 시, UserDefaults에서 다이어리 관련 정보를 가져옵니다.
    static func fetchDiaryData() -> (count: Int, lastWriteDate: Date?) {
        let defaults = UserDefaults(suiteName: UserDefaultsConstant.Diary.suiteName) ?? .standard
        let count = defaults.integer(forKey: UserDefaultsConstant.Diary.countKey)
        let lastWriteDate = defaults.object(forKey: UserDefaultsConstant.Diary.lastWriteDateKey) as? Date
        return (count, lastWriteDate)
    }
}
