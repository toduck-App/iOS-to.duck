import Foundation
import TDCore
import TDData
import TDDomain

public struct ScheduleServiceImpl: ScheduleService {
    private let provider: MFProvider<ScheduleAPI>
    
    public init(provider: MFProvider<ScheduleAPI> = MFProvider<ScheduleAPI>()) {
        self.provider = provider
    }
    
    public func create(schedule: ScheduleRequestDTO) async throws {
        let target = ScheduleAPI.createSchedule(schedule: schedule)
        try await provider.requestDecodable(of: EmptyResponse.self, target)
    }
    
    public func fetchScheduleList(startDate: String, endDate: String) async throws -> ScheduleListContentDTO {
        let target = ScheduleAPI.fetchScheduleList(startDate: startDate, endDate: endDate)
        
        let response = try await provider.requestDecodable(of: ScheduleListContentDTO.self, target).value
        return response
    }
    
    public func finishSchedule(scheduleId: Int, isComplete: Bool, queryDate: String) async throws {
        let target = ScheduleAPI.finishSchedule(scheduleId: scheduleId, isComplete: isComplete, queryDate: queryDate)
        try await provider.requestDecodable(of: EmptyResponse.self, target)
    }
}
