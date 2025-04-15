import TDCore
import TDDomain

public protocol ScheduleService {
    func createSchedule(schedule: ScheduleRequestDTO) async throws
    func updateSchedule(schedule: ScheduleUpdateRequestDTO) async throws
    func fetchScheduleList(startDate: String, endDate: String) async throws -> ScheduleListContentDTO
    func finishSchedule(scheduleId: Int, isComplete: Bool, queryDate: String) async throws
}
