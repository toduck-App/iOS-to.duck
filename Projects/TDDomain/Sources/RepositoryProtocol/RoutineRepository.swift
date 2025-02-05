import TDCore

// MARK: 루틴 하나 상세 불러오기
public protocol RoutineRepository {
    func fetchRoutine() async -> Result<Routine, TDDataError>
    func fetchRoutineList() async -> Result<[Routine], TDDataError>
    func updateRoutine(routineId: Int) async -> Result<Void, TDDataError>
    func deleteRoutine(routineId: Int) async -> Result<Void, TDDataError>
    func createRoutine(routine: Routine) async -> Result<Void, TDDataError>
}
