import Foundation

/// 일정&루틴 UseCase에서 가져온 주간 투두를 담을 모델
public struct WeeklyTodoData {
    public let schedules: [Date: [Schedule]]
    public let routines: [Date: [Routine]]
    
    public init(
        schedules: [Date : [Schedule]],
        routines: [Date : [Routine]]
    ) {
        self.schedules = schedules
        self.routines = routines
    }
}
