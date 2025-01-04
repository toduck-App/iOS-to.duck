import Foundation

public protocol DeleteScheduleUseCase {
    func execute(scheduleId: Int) async throws -> Bool
}

public final class DeleteScheduleUseCaseImpl: DeleteScheduleUseCase {
    private let scheduleRepository: ScheduleRepository
    
    public init(scheduleRepository: ScheduleRepository) {
        self.scheduleRepository = scheduleRepository
    }
    
    public func execute(scheduleId: Int) async throws -> Bool {
        return try await scheduleRepository.deleteSchedule(scheduleId: scheduleId)
    }
}
