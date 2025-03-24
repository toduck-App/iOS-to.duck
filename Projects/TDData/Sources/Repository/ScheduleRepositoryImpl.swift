import TDCore
import TDDomain
import Foundation

public final class ScheduleRepositoryImpl: ScheduleRepository {
    
    public init() { }
    
    public func createSchedule(schedule: Schedule) async throws {
        
    }
    
    public func fetchScheduleList() async throws -> [Schedule] {
        return []
    }
    
    public func fetchSchedule() async throws -> Schedule {
        return
            Schedule(
                id: 0,
                title: "title",
                category: TDCategory(colorHex: "", imageName: ""),
                startDate: "",
                endDate: "",
                isAllDay: false,
                time: nil,
                repeatDays: nil,
                alarmTimes: nil,
                place: nil,
                memo: nil,
                isFinished: false
            )
    }
    
    public func updateSchedule(scheduleId: Int) async throws {
        
    }
    
    public func deleteSchedule(scheduleId: Int) async throws {
        
    }
    
    public func moveTomorrowSchedule(scheduleId: Int) async throws {
        
    }
}
