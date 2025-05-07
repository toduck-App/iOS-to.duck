import Foundation

public protocol FetchRoutineUseCase {
    func execute(routineId: Int) async throws -> Routine
}

public final class FetchRoutineUseCaseImpl: FetchRoutineUseCase {
    private let repository: RoutineRepository
    
    public init(repository: RoutineRepository) {
        self.repository = repository
    }
    
    public func execute(routineId: Int) async throws -> Routine {
        try await repository.fetchRoutine(routineId: routineId)
    }
}
