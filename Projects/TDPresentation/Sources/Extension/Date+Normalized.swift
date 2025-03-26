import Foundation

extension Date {
    var normalized: Date {
        let calendar = Calendar.current
        return calendar.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
}
