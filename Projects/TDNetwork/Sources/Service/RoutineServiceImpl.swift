import Foundation
import TDCore
import TDData
import TDDomain

public struct RoutineServiceImpl: RoutineService {
    private let provider: MFProvider<RoutineAPI>
    
    public init(provider: MFProvider<RoutineAPI> = MFProvider<RoutineAPI>()) {
        self.provider = provider
    }
    
    public func createRoutine(routine: RoutineRequestDTO) async throws {
        let target = RoutineAPI.createRoutine(routine: routine)
        try await provider.requestDecodable(of: EmptyResponse.self, target)
    }
    
    public func finishRoutine(routineId: Int, routineDate: String, isCompleted: Bool) async throws {
        let target = RoutineAPI.finishRoutine(routineId: routineId, routineDate: routineDate, isCompleted: isCompleted)
        try await provider.requestDecodable(of: EmptyResponse.self, target)
    }
    
    public func fetchRoutine(routineId: Int) async throws -> RoutineResponseDTO {
        let target = RoutineAPI.fetchRoutine(routineId: routineId)
        return try await provider.requestDecodable(of: RoutineResponseDTO.self, target).value
    }
    
    public func fetchRoutineList(dateString: String) async throws -> RoutineListResponseDTO {
        let target = RoutineAPI.fetchRoutineList(dateString: dateString)
        return try await provider.requestDecodable(of: RoutineListResponseDTO.self, target).value
    }
    
    public func fetchRoutineListForDates(startDate: String, endDate: String) async throws -> RoutineListForDatesResponseDTO {
        let target = RoutineAPI.fetchRoutineListForDates(startDate: startDate, endDate: endDate)
        return try await provider.requestDecodable(of: RoutineListForDatesResponseDTO.self, target).value
    }
    
    public func fetchAvailableRoutineList() async throws -> RoutineListResponseDTO {
        let target = RoutineAPI.fetchAvailableRoutineList
        return try await provider.requestDecodable(of: RoutineListResponseDTO.self, target).value
    }
    
    public func updateCompleteRoutine(routineId: Int, routineDateString: String, isCompleted: Bool) async throws {
        let target = RoutineAPI.updateCompleteRoutine(routineId: routineId, routineDateString: routineDateString, isCompleted: isCompleted)
        try await provider.requestDecodable(of: EmptyResponse.self, target)
    }
    
    public func updateRoutine(routineId: Int, routine: TDData.RoutineUpdateRequestDTO) async throws {
        let target = RoutineAPI.updateRoutine(routineId: routineId, routine: routine)
        try await provider.requestDecodable(of: EmptyResponse.self, target)
    }
    
    public func deleteRoutineAfterCurrentDay(routineId: Int, keepRecords: Bool) async throws {
        let target = RoutineAPI.deleteRoutineAfterCurrentDay(routineId: routineId, keepRecords: keepRecords)
        try await provider.requestDecodable(of: EmptyResponse.self, target)
    }
}
