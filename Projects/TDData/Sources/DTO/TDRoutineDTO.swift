import TDDomain
import Foundation

public struct TDRoutineDTO: Codable {
    let routineId: Int
    let category: String
    let color: String
    let title: String
    let time: String?
    let isPublic: Bool
    let isInDeletedState: Bool
    let daysOfWeek: [String]
    let memo: String?
    
    public init(
        routineId: Int,
        category: String,
        color: String,
        title: String,
        time: String,
        isPublic: Bool,
        isInDeletedState: Bool,
        daysOfWeek: [String],
        memo: String?
    ) {
        self.routineId = routineId
        self.category = category
        self.color = color
        self.title = title
        self.time = time
        self.isPublic = isPublic
        self.isInDeletedState = isInDeletedState
        self.daysOfWeek = daysOfWeek
        self.memo = memo
    }
    
    func convertToEntity() -> Routine {
        return Routine(
            id: routineId,
            title: title,
            category: TDCategory.init(colorHex: color, imageName: category),
            isAllDay: isInDeletedState,
            isPublic: isPublic,
            time: time,
            repeatDays: daysOfWeek.compactMap { TDWeekDay(rawValue: $0) },
            alarmTime: nil,
            memo: memo,
            recommendedRoutines: nil,
            isFinished: false,
            shareCount: 0
        )
    }
}
