public protocol ShouldMarkAllDayUseCase {
    func execute(with scheduleList: [Schedule]) -> Bool
}

public final class ShouldMarkAllDayUseCaseImpl: ShouldMarkAllDayUseCase {
    public init() {}
    
    public func execute(with scheduleList: [Schedule]) -> Bool {
        let isAllDay = scheduleList.allSatisfy { $0.isAllDay }
        return isAllDay && scheduleList.count >= 3
    }
}
