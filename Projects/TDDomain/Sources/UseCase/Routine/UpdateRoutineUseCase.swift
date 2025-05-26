public protocol UpdateRoutineUseCase {
    func execute(routineId: Int, routine: Routine, preRoutine: Routine) async throws
}

public final class UpdateRoutineUseCaseImpl: UpdateRoutineUseCase {
    private let repository: RoutineRepository
    
    public init(repository: RoutineRepository) {
        self.repository = repository
    }
    
    public func execute(routineId: Int, routine: Routine, preRoutine: Routine) async throws {
        try await repository.updateRoutine(routineId: routineId, routine: routine, preRoutine: preRoutine)
    }
}
