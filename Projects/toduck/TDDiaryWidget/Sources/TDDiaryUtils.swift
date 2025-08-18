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

    /// 지금 기준으로 다음 "정각(00분 00초)"을 반환
    /// 예) 10:17:xx -> 11:00:00, 10:00:00 정확히면 -> 11:00:00
    static func nextHourlyTrigger(after now: Date) -> Date {
        let cal = Calendar.current
        var comps = cal.dateComponents([.year, .month, .day, .hour], from: now)
        comps.minute = 0
        comps.second = 0
        let thisTop = cal.date(from: comps)! // yyyy-MM-dd HH:00:00

        if now < thisTop {
            return thisTop
        } else {
            return cal.date(byAdding: .hour, value: 1, to: thisTop)!
        }
    }
}
