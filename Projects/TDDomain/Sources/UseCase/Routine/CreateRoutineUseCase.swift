import Foundation

public protocol CreateRoutineUseCase {
    func execute(routine: Routine) async throws
}

public final class CreateRoutineUseCaseImpl: CreateRoutineUseCase {
    private let repository: RoutineRepository
    
    public init(repository: RoutineRepository) {
        self.repository = repository
    }
    
    public func execute(routine: Routine) async throws {
        try await repository.createRoutine(routine: routine)
    }
}
