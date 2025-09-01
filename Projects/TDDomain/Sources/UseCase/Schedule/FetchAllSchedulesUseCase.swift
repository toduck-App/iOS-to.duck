import Foundation
import TDCore

public protocol FetchAllSchedulesUseCase {
    func execute(startDate: String, endDate: String) async throws -> [Date: [Schedule]]
}

public final class FetchAllSchedulesUseCaseImpl: FetchAllSchedulesUseCase {
    private let serverUseCase: FetchServerScheduleListUseCase
    private let localUseCase: FetchLocalCalendarScheduleListUseCase
    
    public init(
        serverUseCase: FetchServerScheduleListUseCase,
        localUseCase: FetchLocalCalendarScheduleListUseCase
    ) {
        self.serverUseCase = serverUseCase
        self.localUseCase = localUseCase
    }
    
    public func execute(startDate: String, endDate: String) async throws -> [Date: [Schedule]] {
        async let serverSchedulesTask = serverUseCase.execute(startDate: startDate, endDate: endDate)
        async let localSchedulesTask = localUseCase.execute(startDate: startDate, endDate: endDate)
        
        let (serverSchedules, localSchedules) = try await (serverSchedulesTask, localSchedulesTask)
        
        var combinedSchedules = serverSchedules
        for (date, schedules) in localSchedules {
            combinedSchedules[date, default: []].append(contentsOf: schedules)
        }
        
        return combinedSchedules
    }
}
