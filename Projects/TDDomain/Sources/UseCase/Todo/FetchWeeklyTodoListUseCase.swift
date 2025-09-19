public protocol FetchWeeklyTodoListUseCase {
    func execute(startDate: String, endDate: String) async throws -> WeeklyTodoData
}

public final class FetchWeeklyTodoListUseCaseImpl: FetchWeeklyTodoListUseCase {
    private let fetchScheduleListUseCase: FetchScheduleListUseCase
    private let fetchRoutineListForDatesUseCase: FetchRoutineListForDatesUseCase
    
    init(
        fetchScheduleListUseCase: FetchScheduleListUseCase,
        fetchRoutineListForDatesUseCase: FetchRoutineListForDatesUseCase
    ) {
        self.fetchScheduleListUseCase = fetchScheduleListUseCase
        self.fetchRoutineListForDatesUseCase = fetchRoutineListForDatesUseCase
    }
    
    public func execute(startDate: String, endDate: String) async throws -> WeeklyTodoData {
        async let fetchedSchedules = try fetchScheduleListUseCase.execute(startDate: startDate, endDate:endDate)
        async let fetchedRoutines = try fetchRoutineListForDatesUseCase.execute(startDate: startDate, endDate: endDate)
        
        let (schedules, routines) = try await (fetchedSchedules, fetchedRoutines)
        return WeeklyTodoData(schedules: schedules, routines: routines)
    }
}
