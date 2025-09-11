import Foundation

public protocol UpdateScheduleUseCase {
    func execute(scheduleId: Int, isOneDayDeleted: Bool, queryDate: String, scheduleData: Schedule) async throws
}

public final class UpdateScheduleUseCaseImpl: UpdateScheduleUseCase {
    private let scheduleRepository: ScheduleRepository
    
    public init(repository: ScheduleRepository) {
        self.scheduleRepository = repository
    }
    
    public func execute(scheduleId: Int, isOneDayDeleted: Bool, queryDate: String, scheduleData: Schedule) async throws {
        try await scheduleRepository.updateSchedule(
            scheduleId: scheduleId,
            isOneDayDeleted: isOneDayDeleted,
            queryDate: queryDate,
            scheduleData: scheduleData
        )
    }
}
