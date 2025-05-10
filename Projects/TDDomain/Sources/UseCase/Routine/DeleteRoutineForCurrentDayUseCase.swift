public protocol DeleteRoutineForCurrentDayUseCase {
    func execute(routineId: Int, date: String) async throws
}

public final class DeleteRoutineForCurrentDayUseCaseImpl: DeleteRoutineForCurrentDayUseCase {
    private let repository: RoutineRepository

    public init(repository: RoutineRepository) {
        self.repository = repository
    }

    public func execute(routineId: Int, date: String) async throws {
        try await repository.deleteRoutineForCurrentDay(routineId: routineId, date: date)
    }
}
