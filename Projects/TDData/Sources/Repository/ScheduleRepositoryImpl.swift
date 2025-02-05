import TDCore
import TDDomain
import Foundation

public final class ScheduleRepositoryImpl: ScheduleRepository {
    public init() { }
    
    public func createSchedule(schedule: Schedule) async -> Result<Void, TDDataError> {
        return .success(())
    }
    
    public func fetchScheduleList() async -> Result<[Schedule], TDDataError> {
        return .success([])
    }
    
    public func fetchSchedule() async -> Result<Schedule, TDDataError> {
        return .success(
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
                isFinish: false
            )
        )
    }
    
    public func updateSchedule(scheduleId: Int) async -> Result<Void, TDDataError> {
        return .success(())
    }
    
    public func deleteSchedule(scheduleId: Int) async -> Result<Void, TDDataError> {
        return .success(())
    }
    
    public func moveTomorrowSchedule(scheduleId: Int) async -> Result<Void, TDDataError> {
        return .success(())
    }
}
