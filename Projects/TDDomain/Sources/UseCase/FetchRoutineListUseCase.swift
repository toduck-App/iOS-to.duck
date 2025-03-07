import Foundation

public protocol FetchRoutineListUseCase {
    func execute() async throws -> [Routine]
    func execute(userId: User.ID) async throws -> [Routine]
}

public final class FetchRoutineListUseCaseImpl: FetchRoutineListUseCase {
    private let repository: RoutineRepository
    
    public init(repository: RoutineRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> [Routine] {
        try await repository.fetchRoutineList().get()
    }
    
    public func execute(userId: User.ID) async throws -> [Routine] {
        try await repository.fetchRoutineList(userId: userId).get()
    }
}
