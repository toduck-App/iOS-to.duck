import Foundation

public protocol UpdateRoutineUseCase {
    func execute(routineId: Int) async throws -> Bool
}

public final class UpdateRoutineUseCaseImpl: UpdateRoutineUseCase {
    private let repository: RoutineRepository
    
    public init(repository: RoutineRepository) {
        self.repository = repository
    }
    
    public func execute(routineId: Int) async throws -> Bool {
        return try await repository.updateRoutine(routineId: routineId)
    }
}
