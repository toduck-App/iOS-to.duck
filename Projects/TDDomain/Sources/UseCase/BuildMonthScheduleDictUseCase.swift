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
            guard
                let start = Date.convertFromString(schedule.startDate, format: .yearMonthDay),
                let end = Date.convertFromString(schedule.endDate, format: .yearMonthDay)
            else { continue }

            let effectiveStart = max(start, monthStart)
            let effectiveEnd = min(end, monthEnd)
            let allDates = calendar.generateDates(from: effectiveStart, to: effectiveEnd)

            // 날짜별 ScheduleRecord 매핑
            let recordMap: [Date: ScheduleRecord] = schedule.scheduleRecords?.reduce(into: [:]) { dict, record in
                if let date = Date.convertFromString(record.recordDate, format: .yearMonthDay),
                   record.deletedAt == nil {
                    dict[date] = record
                }
            } ?? [:]

            for date in allDates {
                // 반복 요일 체크 (있는 경우만)
                if let repeatDays = schedule.repeatDays, !repeatDays.contains(date.weekdayEnum()) {
                    continue
                }

                let isFinished = recordMap[date]?.isComplete ?? false
                let clonedSchedule = Schedule(
                    id: schedule.id,
                    title: schedule.title,
                    category: schedule.category,
                    startDate: schedule.startDate,
                    endDate: schedule.endDate,
                    isAllDay: schedule.isAllDay,
                    time: schedule.time,
                    repeatDays: schedule.repeatDays,
                    alarmTime: schedule.alarmTime,
                    place: schedule.place,
                    memo: schedule.memo,
                    isFinished: isFinished,
                    scheduleRecords: schedule.scheduleRecords
                )

                let key = calendar.startOfDay(for: date)
                scheduleDict[key, default: []].append(clonedSchedule)
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
