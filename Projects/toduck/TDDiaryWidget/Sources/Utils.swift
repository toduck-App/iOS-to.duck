import Foundation

enum Utils {
    static func make(hour: Int, from base: Date) -> Date {
        var comp = Calendar.current.dateComponents([.year, .month, .day], from: base)
        comp.hour = hour; comp.minute = 0; comp.second = 0
        return Calendar.current.date(from: comp)!
    }
}


