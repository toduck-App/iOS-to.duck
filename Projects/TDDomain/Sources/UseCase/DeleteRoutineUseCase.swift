import Foundation

public protocol DeleteRoutineUseCase {
    func execute(routineID: Int) async throws -> Bool
}

public final class DeleteRoutineUseCaseImpl: DeleteRoutineUseCase {
    private let repository: RoutineRepository
    
    public init(repository: RoutineRepository) {
        self.repository = repository
    }
    
    public func execute(routineID: Int) async throws -> Bool {
        return try await repository.deleteRoutine(routineId: routineID)
    }
}
