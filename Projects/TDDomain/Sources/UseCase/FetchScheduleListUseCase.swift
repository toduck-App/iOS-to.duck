import TDCore
import Foundation

public protocol FetchScheduleListUseCase {
    func execute(startDate: String, endDate: String) async throws -> [Schedule]
}

public final class FetchScheduleListUseCaseImpl: FetchScheduleListUseCase {
    private let repository: ScheduleRepository
    
    public init(repository: ScheduleRepository) {
        self.repository = repository
    }
    
    public func execute(startDate: String, endDate: String) async throws -> [Schedule] {
        let fetchedScheduleList = try await repository.fetchScheduleList(startDate: startDate, endDate: endDate)
        let filteredScheduleList = filterScheduleList(with: fetchedScheduleList, startDate: startDate, endDate: endDate)
        
        return filteredScheduleList
    }
    
    func filterScheduleList(with scheduleList: [Schedule], startDate: String, endDate: String) -> [Schedule] {
        guard let start = Date.convertFromString(startDate, format: .yearMonthDay),
              let end = Date.convertFromString(endDate, format: .yearMonthDay) else {
            return []
        }

        let calendar = Calendar.current
        let allDates = calendar.generateDates(from: start, to: end)
        var filteredSchedules: Set<Schedule> = []

        for schedule in scheduleList {
            guard let scheduleStart = Date.convertFromString(schedule.startDate, format: .yearMonthDay),
                  let scheduleEnd = Date.convertFromString(schedule.endDate, format: .yearMonthDay) else {
                continue
            }

            let hasPeriod = scheduleStart != scheduleEnd
            let hasRepeat = (schedule.repeatDays?.isEmpty == false)

            switch (hasPeriod, hasRepeat) {
            case (false, false):
                // 1. 기간 X + 반복 X → 하루만 표시
                if allDates.contains(scheduleStart) {
                    filteredSchedules.insert(schedule)
                }

            case (false, true):
                // 2. 기간 X + 반복 O → 모든 날짜 중 반복 요일에 포함된 날만
                for date in allDates {
                    if schedule.repeatDays!.contains(date.weekdayEnum()) {
                        filteredSchedules.insert(schedule)
                        break
                    }
                }

            case (true, false):
                // 3. 기간 O + 반복 X → 기간 내 모든 날짜
                if scheduleEnd < start || scheduleStart > end {
                    continue
                }
                filteredSchedules.insert(schedule)

            case (true, true):
                // 4. 기간 O + 반복 O → 기간 내의 반복 요일에만 표시
                for date in allDates {
                    guard let scheduleRepeatDays = schedule.repeatDays else { continue }
                    if (scheduleStart...scheduleEnd).contains(date),
                       scheduleRepeatDays.contains(date.weekdayEnum()) {
                        filteredSchedules.insert(schedule)
                        break
                    }
                }
            }
        }

        return Array(filteredSchedules)
    }
}
