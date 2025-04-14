public protocol FinishRoutineUseCase {
    func execute(routineId: Int, routineDate: String, isCompleted: Bool) async throws
}

public final class FinishRoutineUseCaseImpl: FinishRoutineUseCase {
    private let repository: RoutineRepository

    public init(repository: RoutineRepository) {
        self.repository = repository
    }
    
    public func execute(routineId: Int, routineDate: String, isCompleted: Bool) async throws {
        try await repository.finishRoutine(routineId: routineId, routineDate: routineDate, isCompleted: isCompleted)
    }
}
