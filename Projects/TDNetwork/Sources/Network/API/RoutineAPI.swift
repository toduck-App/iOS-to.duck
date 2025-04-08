import TDDomain
import Foundation
import TDCore

public enum RoutineAPI {
    case createRoutine(routine: Routine) // 루틴 생성
    case fetchRoutine(routineId: Int) // 하나의 루틴 상세 조회
    case fetchRoutineList(dateString: String) // 모든 루틴 조회
    case fetchAvailableRoutineList // 사용 가능한 루틴 조회
    case updateCompleteRoutine(routineId: Int, routineDateString: String, isCompleted: Bool) // 루틴 완료 상태 변경
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
        case .fetchRoutine(let routineId):
            return "v1/routines/\(routineId)"
        case .fetchRoutineList:
            return "v1/routines/me"
        case .fetchAvailableRoutineList:
            return "v1/routines/me/available"
        case .updateCompleteRoutine(let routineId, _, _):
            return "v1/routines/\(routineId)/completion"
        case .deleteRoutine(let routineId, _):
            return "v1/routines/\(routineId)"
        }
    }
    
    public var method: MFHTTPMethod {
        switch self {
        case .fetchRoutineList, .fetchRoutine, .fetchAvailableRoutineList:
            return .get
        case .createRoutine:
            return .post
        case .updateCompleteRoutine:
            return .put
        case .deleteRoutine:
            return .delete
        }
    }
    
    public var queries: Parameters? {
        switch self {
        case .createRoutine,
                .fetchRoutine,
                .fetchAvailableRoutineList,
                .updateCompleteRoutine:
            return nil
        case .fetchRoutineList(let dateString):
            return [
                "date": dateString
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
             .fetchAvailableRoutineList,
             .deleteRoutine:
            return .requestPlain
        case .createRoutine(let routine):
            return .requestParameters(parameters: [
                "title": routine.title,
                "category": routine.category,
                "color": routine.category.colorHex,
                "time": routine.time ?? "",
                "isPublic": routine.isPublic,
                "daysOfWeek": routine.repeatDays?.map { $0.rawValue } ?? [],
                "reminderMinutes": routine.alarmTime?.rawValue ?? "",
                "memo": routine.memo ?? ""
            ])
        case .updateCompleteRoutine(_, routineDateString: let routineDateString, isCompleted: let isCompleted):
            return .requestParameters(parameters: [
                "routineDate": routineDateString,
                "isCompleted": isCompleted
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
