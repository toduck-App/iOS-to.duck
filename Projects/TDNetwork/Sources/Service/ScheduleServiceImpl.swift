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
            try await provider.requestDecodable(of: ScheduleResponseDTO.self, target)
        } catch {
            throw TDDataError.createRequestFailure
        }
    }
}
