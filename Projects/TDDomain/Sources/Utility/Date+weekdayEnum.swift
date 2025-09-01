import Foundation

extension Date {
    func weekdayEnum() -> TDWeekDay {
        let weekday = Calendar.current.component(.weekday, from: self)
        switch weekday {
        case 1: return .sunday
        case 2: return .monday
        case 3: return .tuesday
        case 4: return .wednesday
        case 5: return .thursday
        case 6: return .friday
        case 7: return .saturday
        default: return .monday
        }
    }
}
