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
        
        do {
            try await provider.requestDecodable(of: EmptyResponse.self, target)
        } catch {
            throw TDDataError.createRequestFailure
        }
    }
    
    public func fetchScheduleList(startDate: String, endDate: String) async throws -> ScheduleListResponseDTO {
        let target = ScheduleAPI.fetchScheduleList(startDate: startDate, endDate: endDate)
        
        do {
            let response = try await provider.requestDecodable(of: ScheduleListResponseDTO.self, target).value
            TDLogger.network("\(#function) - \(response.code) \(response.message)")
            return response
        } catch {
            throw TDDataError.fetchRequestFailure
        }
    }
}
