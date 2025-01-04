import Foundation

public protocol FetchScheduleUseCase {
    func execute() async throws -> Schedule
}

public final class FetchScheduleUseCaseImpl: FetchScheduleUseCase {
    private let scheduleRepository: ScheduleRepository
    
    public init(scheduleRepository: ScheduleRepository) {
        self.scheduleRepository = scheduleRepository
    }
    
    public func execute() async throws -> Schedule {
        return try await scheduleRepository.fetchSchedule()
    }
}
