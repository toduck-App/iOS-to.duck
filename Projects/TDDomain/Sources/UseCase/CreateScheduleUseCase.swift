import Foundation

public protocol CreateScheduleUseCase {
    func execute(schedule: Schedule) async throws -> Bool
}

public final class CreateScheduleUseCaseImpl: CreateScheduleUseCase {
    private let scheduleRepository: ScheduleRepository
    
    public init(scheduleRepository: ScheduleRepository) {
        self.scheduleRepository = scheduleRepository
    }
    
    public func execute(schedule: Schedule) async throws -> Bool {
        return try await scheduleRepository.createSchedule(schedule: schedule)
    }
}
