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
        guard let queryDate = Date.convertFromString(startDate, format: .yearMonthDay) else { return [] }
        let weekdayString = queryDate.convertToString(formatType: .weekday).uppercased()

        guard let weekday = TDWeekDay(rawValue: weekdayString) else {
            TDLogger.error("잘못된 요일 변환: \(weekdayString)")
            return []
        }

        return scheduleList.filter { schedule in
            guard let scheduleStart = Date.convertFromString(schedule.startDate, format: .yearMonthDay),
                  let scheduleEnd = Date.convertFromString(schedule.endDate, format: .yearMonthDay) else {
                return false
            }

            let isWithinPeriod = scheduleStart <= queryDate && queryDate <= scheduleEnd

            if let repeatDays = schedule.repeatDays {
                // 반복 일정 처리
                // - 기간 반복: start ~ end 사이에 있고 요일 포함
                // - 하루 반복: queryDate >= startDate && 요일 포함
                if scheduleStart == scheduleEnd {
                    return queryDate >= scheduleStart && repeatDays.contains(weekday)
                } else {
                    return isWithinPeriod && repeatDays.contains(weekday)
                }
            } else {
                // 일반 일정 (반복 없음): 단순 포함 여부
                return isWithinPeriod
            }
        }
    }
}
