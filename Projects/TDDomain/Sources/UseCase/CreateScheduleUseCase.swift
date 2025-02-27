import Foundation

public protocol CreateScheduleUseCase {
    func execute(schedule: Schedule) async throws
}

public final class CreateScheduleUseCaseImpl: CreateScheduleUseCase {
    private let scheduleRepository: ScheduleRepository
    
    public init(repository: ScheduleRepository) {
        self.scheduleRepository = repository
    }
    
    public func execute(schedule: Schedule) async throws {
        try await scheduleRepository.createSchedule(schedule: schedule).get()
    }
}
