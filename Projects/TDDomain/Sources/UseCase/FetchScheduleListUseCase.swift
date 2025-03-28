import Foundation

public protocol FetchScheduleListUseCase {
    func execute(startDate: String, endDate: String) async throws -> [Schedule]
}

public final class FetchScheduleListUseCaseImpl: FetchScheduleListUseCase {
    private let repository: ScheduleRepository
    
    public init(repository: ScheduleRepository) {
        self.repository = repository
    }
    
    public func execute(startDate: String, endDate: String) async throws -> [Schedule] {
        try await repository.fetchScheduleList(startDate: startDate, endDate: endDate)
    }
}
