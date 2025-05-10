public protocol FinishScheduleUseCase {
    func execute(scheduleId: Int, isComplete: Bool, queryDate: String) async throws
}

public final class FinishScheduleUseCaseImpl: FinishScheduleUseCase {
    private let repository: ScheduleRepository

    public init(repository: ScheduleRepository) {
        self.repository = repository
    }

    public func execute(scheduleId: Int, isComplete: Bool, queryDate: String) async throws {
        try await repository.finishSchedule(scheduleId: scheduleId, isComplete: isComplete, queryDate: queryDate)
    }
}
