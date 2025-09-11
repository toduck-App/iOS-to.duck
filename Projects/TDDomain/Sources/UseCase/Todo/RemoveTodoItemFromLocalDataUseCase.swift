import Foundation

public protocol RemoveTodoItemFromLocalDataUseCase {
    func execute(
        from currentData: WeeklyTodoData,
        eventId: Int,
        on selectedDate: Date,
        isSchedule: Bool
    ) -> WeeklyTodoData
}

public final class RemoveTodoItemFromLocalDataUseCaseImpl: RemoveTodoItemFromLocalDataUseCase {
    public func execute(
        from currentData: WeeklyTodoData,
        eventId: Int,
        on selectedDate: Date,
        isSchedule: Bool
    ) -> WeeklyTodoData {
        let normalizedDate = selectedDate.normalized
        
        if isSchedule {
            var newSchedules = currentData.schedules
            guard var scheduleList = newSchedules[normalizedDate] else {
                return currentData
            }
            
            scheduleList.removeAll { $0.id == eventId }
            newSchedules[normalizedDate] = scheduleList
            
            return WeeklyTodoData(schedules: newSchedules, routines: currentData.routines)
        } else {
            var newRoutines = currentData.routines
            guard var routineList = newRoutines[normalizedDate] else {
                return currentData
            }
            
            routineList.removeAll { $0.id == eventId }
            newRoutines[normalizedDate] = routineList
            
            return WeeklyTodoData(schedules: currentData.schedules, routines: newRoutines)
        }
    }
}
