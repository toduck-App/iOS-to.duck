import Foundation

public protocol UpdateRoutineUseCase {
    func execute(routineId: Int, routineDateString: String, isCompleted: Bool) async throws
}

public final class UpdateRoutineUseCaseImpl: UpdateRoutineUseCase {
    private let repository: RoutineRepository
    
    public init(repository: RoutineRepository) {
        self.repository = repository
    }
    
    public func execute(routineId: Int, routineDateString: String, isCompleted: Bool) async throws {
        try await repository.updateCompleteRoutine(
            routineId: routineId,
            routineDateString: routineDateString,
            isCompleted: isCompleted
        )
    }
}
