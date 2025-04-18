import Foundation
import TDCore

public protocol BuildMonthScheduleDictUseCase {
    func execute(schedules: [Schedule], monthStart: Date, monthEnd: Date) -> [Date: [Schedule]]
}


public final class BuildMonthScheduleDictUseCaseImpl: BuildMonthScheduleDictUseCase {
    public init() {}

    public func execute(schedules: [Schedule], monthStart: Date, monthEnd: Date) -> [Date: [Schedule]] {
        var scheduleDict: [Date: [Schedule]] = [:]
        let calendar = Calendar.current

        for schedule in schedules {
            guard let start = Date.convertFromString(schedule.startDate, format: .yearMonthDay),
                  let end = Date.convertFromString(schedule.endDate, format: .yearMonthDay) else {
                continue
            }

            let effectiveStart = max(start, monthStart)
            let effectiveEnd = min(end, monthEnd)

            let datesInRange = calendar.generateDates(from: effectiveStart, to: effectiveEnd)

            if let repeatDays = schedule.repeatDays, !repeatDays.isEmpty {
                // 반복 일정 처리
                for date in datesInRange {
                    if repeatDays.contains(date.weekdayEnum()) {
                        scheduleDict[date, default: []].append(schedule)
                    }
                }
            } else {
                // 반복 없음 (그냥 날짜 범위만 채움)
                for date in datesInRange {
                    scheduleDict[date, default: []].append(schedule)
                }
            }
        }

        return scheduleDict
    }
}


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
