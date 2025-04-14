import TDCore
import TDDomain

public protocol ScheduleService {
    func create(schedule: ScheduleRequestDTO) async throws
    func fetchScheduleList(startDate: String, endDate: String) async throws -> ScheduleListContentDTO
    func finishSchedule(scheduleId: Int, isComplete: Bool, queryDate: String) async throws
}
