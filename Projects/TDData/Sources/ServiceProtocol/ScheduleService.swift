import TDCore
import TDDomain

public protocol ScheduleService {
    func create(schedule: ScheduleRequestDTO) async throws
}
