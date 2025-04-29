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
    
    public func finishRoutine(routineId: Int, routineDate: String, isCompleted: Bool) async throws {
        try await service.finishRoutine(routineId: routineId, routineDate: routineDate, isCompleted: isCompleted)
    }
    
    public func fetchRoutine(routineId: Int) async throws -> Routine {
        let response = try await service.fetchRoutine(routineId: routineId)
        return response.convertToRoutine()
    }
    
    public func fetchRoutineList(dateString: String) async throws -> [Routine] {
        let response = try await service.fetchRoutineList(dateString: dateString)
        return response.convertToRoutineList()
    }
    
    public func fetchRoutineListForDates(startDate: String, endDate: String) async throws -> [String: [Routine]] {
        let response = try await service.fetchRoutineListForDates(startDate: startDate, endDate: endDate)
        return response.convertToRoutineDictionary()
    }
    
    public func fetchAvailableRoutineList() async throws -> [Routine] {
        let response = try await service.fetchAvailableRoutineList()
        return response.convertToRoutineList()
    }
    
    public func updateRoutine(routineId: Int, routine: Routine, preRoutine: Routine) async throws {
        let requestDTO = RoutineUpdateRequestDTO(from: preRoutine, to: routine)
        try await service.updateRoutine(routineId: routineId, routine: requestDTO)
    }
    
    public func deleteRoutineAfterCurrentDay(routineId: Int, keepRecords: Bool) async throws {
        try await service.deleteRoutineAfterCurrentDay(routineId: routineId, keepRecords: keepRecords)
    }
    }
}
