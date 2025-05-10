public protocol ShareRoutineUseCase {
    func execute(routineID: Routine.ID, routine: Routine) async throws
}

public final class ShareRoutineUseCaseImpl: ShareRoutineUseCase {
    private let repository: UserRepository
    
    public init(repository: UserRepository) {
        self.repository = repository
    }
    
    public func execute(routineID: Routine.ID, routine: Routine) async throws {
        try await repository.shareRoutine(routineID: routineID, routine: routine)
    }
}
