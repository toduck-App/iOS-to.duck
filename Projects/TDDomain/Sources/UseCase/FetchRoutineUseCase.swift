import Foundation

public protocol FetchRoutineUseCase {
    func execute() async throws -> Routine
}

public final class FetchRoutineUseCaseImpl: FetchRoutineUseCase {
    private let repository: RoutineRepository
    
    public init(repository: RoutineRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> Routine {
        try await repository.fetchRoutine().get()
    }
}
