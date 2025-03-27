import TDCore
import TDDomain

public protocol ScheduleService {
    func create(schedule: ScheduleRequestDTO) async throws
    func fetchScheduleList(startDate: String, endDate: String) async throws -> ScheduleListResponseDTO
}
