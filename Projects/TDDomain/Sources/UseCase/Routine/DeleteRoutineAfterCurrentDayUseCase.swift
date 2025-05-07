import Foundation

public protocol DeleteRoutineAfterCurrentDayUseCase {
    func execute(routineId: Int, keepRecords: Bool) async throws
}

public final class DeleteRoutineAfterCurrentDayUseCaseImpl: DeleteRoutineAfterCurrentDayUseCase {
    private let repository: RoutineRepository
    
    public init(repository: RoutineRepository) {
        self.repository = repository
    }
    
    public func execute(routineId: Int, keepRecords: Bool) async throws {
        try await repository.deleteRoutineAfterCurrentDay(routineId: routineId, keepRecords: keepRecords)
    }
}
