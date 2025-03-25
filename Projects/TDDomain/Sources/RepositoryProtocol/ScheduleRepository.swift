import Foundation
import TDCore

public protocol ScheduleRepository {
    func fetchSchedule() async throws -> Schedule
    func fetchScheduleList(startDate: String, endDate: String) async throws -> [Schedule]
    func updateSchedule(scheduleId: Int) async throws
    func deleteSchedule(scheduleId: Int) async throws
    func moveTomorrowSchedule(scheduleId: Int) async throws
    func createSchedule(schedule: Schedule) async throws
}
