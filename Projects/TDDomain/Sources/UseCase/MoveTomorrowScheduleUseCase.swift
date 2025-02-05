import Foundation

public protocol MoveTomorrowScheduleUseCase {
    func execute(scheduleId: Int) async throws
}

public final class MoveTomorrowScheduleUseCaseImpl: MoveTomorrowScheduleUseCase {
    private let scheduleRepository: ScheduleRepository
    
    public init(repository: ScheduleRepository) {
        self.scheduleRepository = repository
    }
    
    public func execute(scheduleId: Int) async throws {
        try await scheduleRepository.moveTomorrowSchedule(scheduleId: scheduleId).get()
    }
}
