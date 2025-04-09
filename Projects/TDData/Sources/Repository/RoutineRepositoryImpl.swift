import TDCore
import TDDomain

public final class RoutineRepositoryImpl: RoutineRepository {
    private let service: RoutineService
    
    public init(service: RoutineService) {
        self.service = service
    }
    
    public func createRoutine(routine: Routine) async throws {
        let requestDTO = RoutineRequestDTO(from: routine)
        try await service.createRoutine(routine: requestDTO)
    }
    
    public func fetchRoutine(routineId: Int) async throws -> Routine {
        let response = try await service.fetchRoutine(routineId: routineId)
        return response.convertToRoutine()
    }
    
    public func fetchRoutineList(dateString: String) async throws -> [Routine] {
        let response = try await service.fetchRoutineList(dateString: dateString)
        return response.convertToRoutineList()
    }
    
    public func fetchAvailableRoutineList() async throws -> [Routine] {
        let response = try await service.fetchAvailableRoutineList()
        return response.convertToRoutineList()
    }
    
    public func updateCompleteRoutine(routineId: Int, routineDateString: String, isCompleted: Bool) async throws {
        try await service.updateCompleteRoutine(routineId: routineId, routineDateString: routineDateString, isCompleted: isCompleted)
    }
    
    public func deleteRoutine(routineId: Int, keepRecords: Bool) async throws {
        try await service.deleteRoutine(routineId: routineId, keepRecords: keepRecords)
    }
}
