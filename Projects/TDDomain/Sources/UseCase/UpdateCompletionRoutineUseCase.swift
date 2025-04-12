import Foundation

public protocol UpdateCompletionRoutineUseCase {
    func execute(routineId: Int, routineDateString: String, isCompleted: Bool) async throws
}

public final class UpdateCompletionRoutineUseCaseImpl: UpdateCompletionRoutineUseCase {
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
