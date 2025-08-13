import Foundation
import TDCore

enum Utils {
    static func make(hour: Int, from base: Date) -> Date {
        var comp = Calendar.current.dateComponents([.year, .month, .day], from: base)
        comp.hour = hour; comp.minute = 0; comp.second = 0
        return Calendar.current.date(from: comp)!
    }

    static func read() -> (count: Int, lastWriteDate: Date?) {
        let defaults = UserDefaults(suiteName: UserDefaultsConstant.Diary.suiteName) ?? .standard
        let count = defaults.integer(forKey: UserDefaultsConstant.Diary.countKey)
        let lastWriteDate = defaults.object(forKey: UserDefaultsConstant.Diary.lastWriteDateKey) as? Date
        return (count, lastWriteDate)
    }
}
