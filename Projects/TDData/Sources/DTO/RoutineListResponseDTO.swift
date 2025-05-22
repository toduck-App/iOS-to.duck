import TDDomain
import Foundation

public struct RoutineListResponseDTO: Decodable {
    public let queryDate: String?
    public let routines: [RoutineListDetail]
    
    public func convertToRoutineList() -> [Routine] {
        routines.map { routine in
            Routine(
                id: routine.routineId,
                title: routine.title,
                category: TDCategory(colorHex: routine.color, imageName: routine.category),
                isAllDay: routine.time == nil,
                isPublic: routine.isPublic,
                time: routine.time,
                repeatDays: routine.daysOfWeek?.compactMap { TDWeekDay(rawValue: $0) },
                alarmTime: nil,
                memo: routine.memo,
                recommendedRoutines: nil,
                isFinished: routine.isCompleted ?? false,
                shareCount: routine.sharedCount ?? 0
            )
        }
    }
}

public struct RoutineListDetail: Decodable {
    public let routineId: Int
    public let color: String
    public let category: String
    public let daysOfWeek: [String]?
    public let time: String?
    public let title: String
    public let isPublic: Bool
    public let memo: String?
    public let isCompleted: Bool?
    public let sharedCount: Int?
}
