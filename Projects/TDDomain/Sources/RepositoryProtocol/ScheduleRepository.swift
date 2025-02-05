import Foundation
import TDCore

public protocol ScheduleRepository {
    func fetchSchedule() async -> Result<Schedule, TDDataError>
    func fetchScheduleList() async -> Result<[Schedule], TDDataError>
    func updateSchedule(scheduleId: Int) async -> Result<Void, TDDataError>
    func deleteSchedule(scheduleId: Int) async -> Result<Void, TDDataError>
    func moveTomorrowSchedule(scheduleId: Int) async -> Result<Void, TDDataError>
    func createSchedule(schedule: Schedule) async -> Result<Void, TDDataError>
}
