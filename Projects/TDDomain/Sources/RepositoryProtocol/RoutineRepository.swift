import TDCore

// MARK: 루틴 하나 상세 불러오기
public protocol RoutineRepository {
    func createRoutine(routine: Routine) async throws
    func fetchRoutine(routineId: Int) async throws -> Routine
    func fetchRoutineList(dateString: String) async throws -> [Routine]
    func fetchAvailableRoutineList() async throws -> [Routine]
    func updateCompleteRoutine(routineId: Int, routineDateString: String, isCompleted: Bool) async throws
    func deleteRoutine(routineId: Int, keepRecords: Bool) async throws
}
