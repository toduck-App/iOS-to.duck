import Foundation

public protocol FetchRoutineListUseCase {
    func execute(dateString: String) async throws -> [Routine]
}

public final class FetchRoutineListUseCaseImpl: FetchRoutineListUseCase {
    private let repository: RoutineRepository
    
    public init(repository: RoutineRepository) {
        self.repository = repository
    }
    
    public func execute(dateString: String) async throws -> [Routine] {
        try await repository.fetchRoutineList(dateString: dateString)
    }
}
