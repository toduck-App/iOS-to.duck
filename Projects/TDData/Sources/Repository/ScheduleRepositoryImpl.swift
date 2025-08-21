import TDCore
import TDDomain
import Foundation

public final class ScheduleRepositoryImpl: ScheduleRepository {
    private let service: ScheduleService
    
    public init(service: ScheduleService) {
        self.service = service
    }
    
    public func createSchedule(schedule: Schedule) async throws {
        let scheduleRequestDTO = ScheduleRequestDTO(schedule: schedule)
        try await service.createSchedule(schedule: scheduleRequestDTO)
    }
    
    public func fetchServerScheduleList(startDate: String, endDate: String) async throws -> [Schedule] {
        let responseDTO = try await service.fetchScheduleList(startDate: startDate, endDate: endDate)
        return responseDTO.scheduleHeadDtos.map { $0.convertToSchedule() }
    }
    
    public func finishSchedule(scheduleId: Int, isComplete: Bool, queryDate: String) async throws {
        try await service.finishSchedule(scheduleId: scheduleId, isComplete: isComplete, queryDate: queryDate)
    }
    
    public func updateSchedule(scheduleId: Int, isOneDayDeleted: Bool, queryDate: String, scheduleData: Schedule) async throws {
        let scheduleData = ScheduleDataDTO(schedule: scheduleData)
        let scheduleUpdateRequestDTO = ScheduleUpdateRequestDTO(
            scheduleId: scheduleId,
            isOneDayDeleted: isOneDayDeleted,
            queryDate: queryDate,
            scheduleData: scheduleData
        )
        try await service.updateSchedule(schedule: scheduleUpdateRequestDTO)
    }
    
    public func deleteSchedule(scheduleId: Int, isOneDayDeleted: Bool, queryDate: String) async throws {
        try await service.deleteSchedule(
            scheduleId: scheduleId,
            isOneDayDeleted: isOneDayDeleted,
            queryDate: queryDate
        )
    }
}
