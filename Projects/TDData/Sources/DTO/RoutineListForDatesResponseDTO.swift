import TDDomain
import Foundation

public struct RoutineListForDatesResponseDTO: Decodable {
    public let startDate: String?
    public let endDate: String?
    public let dateRoutines: [RoutineListResponseDTO]
    
    public func convertToRoutineDictionary() -> [String: [Routine]] {
        var routineDict: [String: [Routine]] = [:]
        
        for dateRoutine in dateRoutines {
            guard let date = dateRoutine.queryDate else { continue }
            
            var routines: [Routine] = []
            
            for detail in dateRoutine.routines {
                let routine = Routine(
                    id: detail.routineId,
                    title: detail.title,
                    category: TDCategory(colorHex: detail.color, imageName: detail.category),
                    isAllDay: detail.time == nil,
                    isPublic: detail.isPublic,
                    time: detail.time,
                    repeatDays: detail.daysOfWeek?.compactMap { TDWeekDay(rawValue: $0) },
                    alarmTime: nil,
                    memo: detail.memo,
                    recommendedRoutines: nil,
                    isFinished: detail.isCompleted ?? false,
                    shareCount: detail.sharedCount ?? 0
                )
                routines.append(routine)
            }
            
            routineDict[date] = routines
        }
        
        return routineDict
    }
}
