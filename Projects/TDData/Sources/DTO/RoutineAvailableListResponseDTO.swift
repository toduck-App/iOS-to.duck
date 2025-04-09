import TDDomain
import Foundation

// 소셜 34 페이지, 내 루틴 공유할 때 쓰이는 DTO 입니다.
public struct RoutineAvailableListResponseDTO: Decodable {
    let routines: [RoutineAvailableListDetail]
    
    func convertToRoutine() -> [Routine] {
        routines.map { routine in
            Routine(
                id: routine.routineId,
                title: routine.title,
                category: TDCategory(colorHex: routine.color, imageName: routine.category),
                isAllDay: false,
                isPublic: true, // 공개된 루틴만 보임
                time: nil,
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
    let memo: String?
}
