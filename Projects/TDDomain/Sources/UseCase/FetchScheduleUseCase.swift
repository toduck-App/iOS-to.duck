import Foundation

public protocol FetchScheduleUseCase {
    func execute() async throws -> Schedule
}

public final class FetchScheduleUseCaseImpl: FetchScheduleUseCase {
    private let scheduleRepository: ScheduleRepository
    
    public init(repository: ScheduleRepository) {
        self.scheduleRepository = repository
    }
    
    public func execute() async throws -> Schedule {
        try await scheduleRepository.fetchSchedule().get()
    }
}
