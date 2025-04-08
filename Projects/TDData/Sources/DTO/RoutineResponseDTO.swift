import TDCore
import Foundation
import TDDomain

public struct RoutineResponseDTO: Decodable {
    let routineId: Int
    let category: String
    let color: String
    let title: String
    let time: String?
    let isPublic: Bool
    let isInDeletedState: Bool
    let daysOfWeek: [String]
    let memo: String?
    
    func convertToRoutine() -> Routine {
        let routineTime: Date? = time != nil ? Date.convertFromString(time!, format: .time24Hour) : nil
            
            return Routine(
                id: routineId,
                title: title,
                category: TDCategory(colorHex: color, imageName: category),
                isAllDay: time == nil, // time이 없으면 isAllDay가 true
                isPublic: isPublic,
                time: routineTime,
                repeatDays: daysOfWeek.compactMap { TDWeekDay(rawValue: $0) },
                alarmTime: nil,
                memo: memo,
                recommendedRoutines: nil,
                isFinished: false,
                shareCount: 0
            )
        }
}
