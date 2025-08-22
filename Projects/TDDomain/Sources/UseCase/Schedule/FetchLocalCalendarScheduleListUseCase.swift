import Foundation

public protocol FetchLocalCalendarScheduleListUseCase {
    func execute(startDate: String, endDate: String) async throws -> [Date: [Schedule]]
}

public final class FetchLocalCalendarScheduleListUseCaseImpl: FetchLocalCalendarScheduleListUseCase {
    private let repository: ScheduleRepository
    
    public init(repository: ScheduleRepository) {
        self.repository = repository
    }
    
    public func execute(
        startDate: String,
        endDate: String
    ) async throws -> [Date: [Schedule]] {
        let schedules = try await repository.fetchLocalCalendarScheduleList(
            startDate: startDate,
            endDate: endDate
        )
        
        return groupSchedulesByDay(schedules: schedules)
    }
    
    private func groupSchedulesByDay(schedules: [Schedule]) -> [Date: [Schedule]] {
        var groupedDictionary = [Date: [Schedule]]()
        let calendar = Calendar.current
        
        for schedule in schedules {
            guard
                let startDate = Date.convertFromString(schedule.startDate, format: .yearMonthDay),
                let endDate = Date.convertFromString(schedule.endDate, format: .yearMonthDay)
            else { continue }
            
            var currentDate = startDate
            while calendar.startOfDay(for: currentDate) <= calendar.startOfDay(for: endDate) {
                let dayKey = calendar.startOfDay(for: currentDate)
                groupedDictionary[dayKey, default: []].append(schedule)
                
                if let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                    currentDate = nextDay
                } else {
                    break
                }
            }
        }
        
        return groupedDictionary
    }
}
