import TDDomain
import Foundation

public struct RoutineListResponseDTO: Decodable {
    let queryDate: String?
    let routines: [RoutineListDetail]
    
    func convertToRoutineList() -> [Routine] {
        routines.map { routine in
            let routineTime: Date? = routine.time != nil ? Date.convertFromString(routine.time!, format: .time24Hour) : nil
            
            return Routine(
                id: routine.routineId,
                title: routine.title,
                category: TDCategory(colorHex: routine.color, imageName: routine.category),
                isAllDay: routine.time == nil,
                isPublic: false,
                time: routineTime,
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
    let routineId: Int
    let color: String
    let category: String
    let daysOfWeek: [String]?
    let time: String?
    let title: String
    let memo: String?
    let isCompleted: Bool?
    let sharedCount: Int?
}
