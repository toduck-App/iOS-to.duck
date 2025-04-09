import Foundation

public protocol DeleteRoutineUseCase {
    func execute(routineId: Int, keepRecords: Bool) async throws
}

public final class DeleteRoutineUseCaseImpl: DeleteRoutineUseCase {
    private let repository: RoutineRepository
    
    public init(repository: RoutineRepository) {
        self.repository = repository
    }
    
    public func execute(routineId: Int, keepRecords: Bool) async throws {
        try await repository.deleteRoutine(routineId: routineId, keepRecords: keepRecords)
    }
}
