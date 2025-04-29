import TDDomain
import TDData
import Foundation
import TDCore

public enum RoutineAPI {
    case createRoutine(routine: RoutineRequestDTO) // 루틴 생성
    case finishRoutine(routineId: Int, routineDate: String, isCompleted: Bool) // 루틴 완료
    case fetchRoutine(routineId: Int) // 하나의 루틴 상세 조회
    case fetchRoutineList(dateString: String) // 모든 루틴 조회
    case fetchRoutineListForDates(startDate: String, endDate: String) // 날짜 범위에 따른 루틴 조회
    case fetchAvailableRoutineList // 사용 가능한 루틴 조회
    case updateCompleteRoutine(routineId: Int, routineDateString: String, isCompleted: Bool) // 루틴 완료 상태 변경
    case updateRoutine(routineId: Int, routine: RoutineUpdateRequestDTO) // 루틴 수정
    case deleteRoutine(routineId: Int, keepRecords: Bool) // 루틴 삭제
}

extension RoutineAPI: MFTarget {
    public var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    public var path: String {
        switch self {
        case .createRoutine:
            return "v1/routines"
        case .finishRoutine(let routineId, _, _):
            return "v1/routines/\(routineId)/completion"
        case .fetchRoutine(let routineId):
            return "v1/routines/\(routineId)"
        case .fetchRoutineList:
            return "v1/routines/me"
        case .fetchRoutineListForDates:
            return "/v1/routines/me/dates"
        case .fetchAvailableRoutineList:
            return "v1/routines/me/available"
        case .updateCompleteRoutine(let routineId, _, _):
            return "v1/routines/\(routineId)/completion"
        case .updateRoutine(let routineId, _):
            return "v1/routines/\(routineId)"
        case .deleteRoutine(let routineId, _):
            return "v1/routines/\(routineId)"
        }
    }
    
    public var method: MFHTTPMethod {
        switch self {
        case .createRoutine:
            return .post
        case .finishRoutine:
            return .put
        case .fetchRoutineList, .fetchRoutine, .fetchRoutineListForDates, .fetchAvailableRoutineList:
            return .get
        case .updateCompleteRoutine,
                .updateRoutine:
            return .put
        case .deleteRoutine:
            return .delete
        }
    }
    
    public var queries: Parameters? {
        switch self {
        case .createRoutine,
                .finishRoutine,
                .fetchRoutine,
                .fetchAvailableRoutineList,
                .updateCompleteRoutine,
                .updateRoutine:
            return nil
        case .fetchRoutineList(let dateString):
            return [
                "date": dateString
            ]
        case .fetchRoutineListForDates(let startDate, let endDate):
            return [
                "startDate": startDate,
                "endDate": endDate
            ]
        case .deleteRoutine(_, let keepRecords):
            return [
                "keepRecords": keepRecords
            ]
        }
    }
    
    public var task: MFTask {
        switch self {
        case .fetchRoutineList,
                .fetchRoutine,
                .fetchRoutineListForDates,
                .fetchAvailableRoutineList,
                .deleteRoutine:
            return .requestPlain
        case .finishRoutine(_, let routineDate, let isCompleted):
            return .requestParameters(parameters: [
                "routineDate": routineDate,
                "isCompleted": isCompleted
            ])
        case .createRoutine(let routine):
            return .requestParameters(parameters: [
                "title": routine.title,
                "category": routine.category,
                "color": routine.color,
                "time": routine.time ?? "",
                "isPublic": routine.isPublic,
                "daysOfWeek": routine.daysOfWeek.map { $0 } ?? [],
                "reminderMinutes": routine.reminderMinutes ?? 0,
                "memo": routine.memo ?? ""
            ])
        case .updateCompleteRoutine(_, routineDateString: let routineDateString, isCompleted: let isCompleted):
            return .requestParameters(parameters: [
                "routineDate": routineDateString,
                "isCompleted": isCompleted
            ])
        case .updateRoutine(_, let routine):
            return .requestParameters(parameters: [
                "title": routine.title,
                "category": routine.category,
                "color": routine.color,
                "time": routine.time ?? "",
                "isPublic": routine.isPublic,
                "daysOfWeek": routine.daysOfWeek.map { $0 } ?? [],
                "reminderMinutes": routine.reminderMinutes ?? 0,
                "memo": routine.memo ?? "",
                "isTitleChanged": routine.isTitleChanged,
                "isCategoryChanged": routine.isCategoryChanged,
                "isColorChanged": routine.isColorChanged,
                "isTimeChanged": routine.isTimeChanged,
                "isPublicChanged": routine.isPublicChanged,
                "isDaysOfWeekChanged": routine.isDaysOfWeekChanged,
                "isReminderMinutesChanged": routine.isReminderMinutesChanged,
                "isMemoChanged": routine.isMemoChanged
            ])
        }
    }
    
    public var headers: MFHeaders? {
        let jsonHeaders: MFHeaders = [
            .contentType("application/json"),
            .authorization(bearerToken: TDTokenManager.shared.accessToken ?? "")
        ]
        return jsonHeaders
    }
}
