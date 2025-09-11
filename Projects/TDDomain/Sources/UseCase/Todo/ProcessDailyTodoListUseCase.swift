import Foundation
import TDCore

public protocol ProcessDailyTodoListUseCase {
    func execute(from weeklyData: WeeklyTodoData, for selectedDate: Date) -> DailyTodoList
}

public final class ProcessDailyTodoListUseCaseImpl: ProcessDailyTodoListUseCase {
    public func execute(from weeklyData: WeeklyTodoData, for selectedDate: Date) -> DailyTodoList {
        let normalizedDate = selectedDate.normalized
        
        let schedulesForDate = weeklyData.schedules[normalizedDate] ?? []
        let routinesForDate = weeklyData.routines[normalizedDate] ?? []
        
        let combinedList: [any TodoItem] = (schedulesForDate as [any TodoItem]) + (routinesForDate as [any TodoItem])
        
        let allDayItems = combinedList.filter { $0.time == nil }
        let timedItems = combinedList
            .filter { $0.time != nil }
            .sorted { Date.timeSortKey($0.time) < Date.timeSortKey($1.time) }
            
        return DailyTodoList(allDayItems: allDayItems, timedItems: timedItems)
    }
}
