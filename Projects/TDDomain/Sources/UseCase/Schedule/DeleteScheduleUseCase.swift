import Foundation
import TDCore

public protocol DeleteScheduleUseCase {
    func execute(scheduleId: Int, isOneDayDeleted: Bool, queryDate: String) async throws
}

public final class DeleteScheduleUseCaseImpl: DeleteScheduleUseCase {
    private let scheduleRepository: ScheduleRepository
    
    public init(repository: ScheduleRepository) {
        self.scheduleRepository = repository
    }
    
    public func execute(scheduleId: Int, isOneDayDeleted: Bool, queryDate: String) async throws {
        try await scheduleRepository.deleteSchedule(
            scheduleId: scheduleId,
            isOneDayDeleted: isOneDayDeleted,
            queryDate: queryDate
        )
    }
}
