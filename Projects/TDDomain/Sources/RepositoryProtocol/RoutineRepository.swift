public protocol RoutineRepository {
    func createRoutine(routine: Routine) async throws
    func finishRoutine(routineId: Int, routineDate: String, isCompleted: Bool) async throws
    func fetchRoutine(routineId: Int) async throws -> Routine
    func fetchRoutineList(dateString: String) async throws -> [Routine]
    func fetchRoutineListForDates(startDate: String, endDate: String) async throws -> [String: [Routine]]
    func fetchAvailableRoutineList() async throws -> [Routine]
    func updateRoutine(routineId: Int, routine: Routine, preRoutine: Routine) async throws
    func deleteRoutineAfterCurrentDay(routineId: Int, keepRecords: Bool) async throws
}
