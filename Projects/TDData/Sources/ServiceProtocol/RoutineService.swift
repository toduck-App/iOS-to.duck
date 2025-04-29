public protocol RoutineService {
    func createRoutine(routine: RoutineRequestDTO) async throws
    func finishRoutine(routineId: Int, routineDate: String, isCompleted: Bool) async throws
    func fetchRoutine(routineId: Int) async throws -> RoutineResponseDTO
    func fetchRoutineList(dateString: String) async throws -> RoutineListResponseDTO
    func fetchRoutineListForDates(startDate: String, endDate: String) async throws -> RoutineListForDatesResponseDTO
    func fetchAvailableRoutineList() async throws -> RoutineListResponseDTO
    func updateCompleteRoutine(routineId: Int, routineDateString: String, isCompleted: Bool) async throws
    func updateRoutine(routineId: Int, routine: RoutineUpdateRequestDTO) async throws
    func deleteRoutine(routineId: Int, keepRecords: Bool) async throws
}
