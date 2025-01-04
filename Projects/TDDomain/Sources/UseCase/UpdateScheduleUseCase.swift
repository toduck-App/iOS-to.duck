import Foundation

public protocol UpdateScheduleUseCase {
    func execute(scheduleId: Int) async throws -> Bool
}

public final class UpdateScheduleUseCaseImpl: UpdateScheduleUseCase {
    private let scheduleRepository: ScheduleRepository
    
    public init(scheduleRepository: ScheduleRepository) {
        self.scheduleRepository = scheduleRepository
    }
    
    public func execute(scheduleId: Int) async throws -> Bool {
        return try await scheduleRepository.updateSchedule(scheduleId: scheduleId)
    }
}
