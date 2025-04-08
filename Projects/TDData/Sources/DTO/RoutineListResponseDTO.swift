import TDDomain
import Foundation

public struct RoutineListResponseDTO: Decodable {
    let queryDate: String
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
                repeatDays: nil,
                alarmTime: nil,
                memo: nil,
                recommendedRoutines: nil,
                isFinished: routine.isCompleted
            )
        }
    }
}

public struct RoutineListDetail: Decodable {
    let routineId: Int
    let color: String
    let category: String
    let time: String?
    let title: String
    let isCompleted: Bool
}
