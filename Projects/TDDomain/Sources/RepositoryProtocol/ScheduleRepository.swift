import Foundation
import TDCore

public protocol ScheduleRepository {
    func createSchedule(schedule: Schedule) async throws
    func finishSchedule(scheduleId: Int, isComplete: Bool, queryDate: String) async throws
    func fetchSchedule() async throws -> Schedule
    func fetchScheduleList(startDate: String, endDate: String) async throws -> [Schedule]
    func updateSchedule(scheduleId: Int, isOneDayDeleted: Bool, queryDate: String, scheduleData: Schedule) async throws
    func deleteSchedule(scheduleId: Int, isOneDayDeleted: Bool, queryDate: String) async throws
    func moveTomorrowSchedule(scheduleId: Int) async throws
}
