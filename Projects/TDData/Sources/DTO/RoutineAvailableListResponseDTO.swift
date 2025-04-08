import TDDomain
import Foundation

public struct RoutineAvailableListResponseDTO: Decodable {
    let routines: [RoutineAvailableListDetail]
    
    func convertToRoutine() -> [Routine] {
        routines.map { routine in
            let routineTime: Date? = routine.time != nil ? Date.convertFromString(routine.time!, format: .time24Hour) : nil
            
            return Routine(
                id: routine.routineId,
                title: routine.title,
                category: TDCategory(colorHex: routine.color, imageName: routine.category),
                isAllDay: time == nil,
                isPublic: true,
                time: routineTime,
                repeatDays: nil,
                alarmTime: nil,
                memo: routine.memo,
                recommendedRoutines: nil,
                isFinished: false
            )
        }
    }
}

public struct RoutineAvailableListDetail: Decodable {
    let routineId: Int
    let category: String
    let color: String
    let title: String
    let time: String?
    let memo: String?
}
