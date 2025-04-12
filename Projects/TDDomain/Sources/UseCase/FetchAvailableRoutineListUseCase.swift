public protocol FetchAvailableRoutineListUseCase {
    func execute() async throws -> [Routine]
}

public final class FetchAvailableRoutineListUseCaseImpl: FetchAvailableRoutineListUseCase {
    private let repository: RoutineRepository
    
    public init(repository: RoutineRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> [Routine] {
        return try await repository.fetchAvailableRoutineList()
    }
}
