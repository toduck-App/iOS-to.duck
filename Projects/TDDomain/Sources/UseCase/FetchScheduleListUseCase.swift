import Foundation

public protocol FetchScheduleListUseCase {
    func execute() async throws -> [Schedule]
}

public final class FetchScheduleListUseCaseImpl: FetchScheduleListUseCase {
    private let repository: ScheduleRepository
    
    public init(repository: ScheduleRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> [Schedule] {
        return try await repository.fetchScheduleList()
    }
}
