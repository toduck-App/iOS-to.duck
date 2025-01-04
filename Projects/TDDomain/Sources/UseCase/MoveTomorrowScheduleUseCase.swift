import Foundation

public protocol MoveTomorrowScheduleUseCase {
    func execute(scheduleId: Int) async throws -> Bool
}

public final class MoveTomorrowScheduleUseCaseImpl: MoveTomorrowScheduleUseCase {
    private let scheduleRepository: ScheduleRepository
    
    public init(scheduleRepository: ScheduleRepository) {
        self.scheduleRepository = scheduleRepository
    }
    
    public func execute(scheduleId: Int) async throws -> Bool {
        return try await scheduleRepository.moveTomorrowSchedule(scheduleId: scheduleId)
    }
}
