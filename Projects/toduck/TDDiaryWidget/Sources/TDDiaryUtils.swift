import Foundation
import TDCore

enum TDDiaryUtils {
    /// 주어진 날짜에 해당하는 시각의 Date 객체를 생성합니다.
    static func makeDate(hour: Int, minute: Int = 0, from base: Date) -> Date {
        var comp = Calendar.current.dateComponents([.year, .month, .day], from: base)
        comp.hour = hour; comp.minute = minute; comp.second = 0
        return Calendar.current.date(from: comp)!
    }

    /// 데이터 Fetch 요청 시, UserDefaults에서 다이어리 관련 정보를 가져옵니다.
    static func fetchDiaryData() -> (count: Int, lastWriteDate: Date?) {
        let defaults = UserDefaults(suiteName: UserDefaultsConstant.Diary.suiteName) ?? .standard
        let count = defaults.integer(forKey: UserDefaultsConstant.Diary.countKey)
        let lastWriteDate = defaults.object(forKey: UserDefaultsConstant.Diary.lastWriteDateKey) as? Date
        return (count, lastWriteDate)
    }

    /// 주어진 날짜의 21:00 ~ 23:00 사이를 15분 간격으로 생성 (끝점 23:00 포함)
    static func makeQuarterHourSchedule(on day: Date, startHour: Int = 21, endHour: Int = 23, intervalMinutes: Int = 15) -> [Date] {
        let cal = Calendar.current
        var cursor = cal.date(bySettingHour: startHour, minute: 0, second: 0, of: day)!
        let end = cal.date(bySettingHour: endHour, minute: 0, second: 0, of: day)!
        var result: [Date] = []
        while cursor <= end {
            result.append(cursor)
            cursor = cal.date(byAdding: .minute, value: intervalMinutes, to: cursor)!
        }
        return result
    }

    /// 다음 트리거 한 번만 알고 싶을 때 사용
    static func nextQuarterHourTrigger(after now: Date, startHour: Int = 21, endHour: Int = 23, intervalMinutes: Int = 15) -> Date {
        let cal = Calendar.current
        let today = makeQuarterHourSchedule(on: now, startHour: startHour, endHour: endHour, intervalMinutes: intervalMinutes)
        if let next = today.first(where: { $0 > now }) {
            return next
        }
        let tomorrow = cal.date(byAdding: .day, value: 1, to: now)!
        return makeQuarterHourSchedule(on: tomorrow, startHour: startHour, endHour: endHour, intervalMinutes: intervalMinutes).first!
    }
}
