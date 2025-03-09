import TDDomain
import Foundation

public enum RoutineAPI {
    case fetchRoutineList // 모든 루틴 조회
    case createRoutine(routine: Routine) // 루틴 생성
    case fetchRoutine(routineId: Int) // 특정 루틴 조회
    case updateRoutine(routineId: Int, routine: Routine) // 루틴 업데이트
    case deleteRoutine(routineId: Int) // 루틴 삭제
}

extension RoutineAPI: MFTarget {
    public var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    public var path: String {
        switch self {
        case .fetchRoutineList:
            return "/routines"
        case .createRoutine:
            return "/routines"
        case .fetchRoutine(let routineId):
            return "/routines/\(routineId)"
        case .updateRoutine(let routineId, _):
            return "/routines/\(routineId)"
        case .deleteRoutine(let routineId):
            return "/routines/\(routineId)"
        }
    }
    
    public var method: MFHTTPMethod {
        switch self {
        case .fetchRoutineList, .fetchRoutine:
            return .get
        case .createRoutine:
            return .post
        case .updateRoutine:
            return .put
        case .deleteRoutine:
            return .delete
        }
    }
    
    public var queries: Parameters? {
        // TODO: - API에 따라 이 부분도 구현되어야 합니다.
        return nil
    }
    
    public var task: MFTask {
        switch self {
        case .fetchRoutineList,
             .fetchRoutine,
             .deleteRoutine:
            return .requestPlain
        case .createRoutine(let routine),
             .updateRoutine(_, let routine):
            // TODO: - 아직 구현 전?
            return .requestPlain
        }
    }
    
    public var headers: MFHeaders? {
        let jsonHeaders: MFHeaders = [
            .contentType("application/json")
        ]
        // TODO: - 나중에 회의 후 결정
        return jsonHeaders
    }
}

extension RoutineAPI {
    public var sampleData: Data {
        switch self {
        case .fetchRoutineList:
            return """
                [
                    {
                        "id": 1,
                        "title": "아침운동",
                        "category": "운동",
                        "isPublic": true,
                        "dateAndTime": "2024-07-09T07:30:00Z",
                        "isRepeating": true,
                        "isRepeatAllDay": false,
                        "repeatDays": ["월", "수", "금"],
                        "alarm": true,
                        "alarmTimes": ["60", "10"],
                        "memo": "아침에 일어나서 운동하기",
                        "recommendedRoutines": ["스트래칭 하기", "달리기"],
                        "isFinish": false
                    },
                    {
                        "id": 2,
                        "title": "팀 미팅",
                        "category": "일",
                        "isPublic": false,
                        "dateAndTime": "2024-07-09T09:00:00Z",
                        "isRepeating": false,
                        "isRepeatAllDay": false,
                        "repeatDays": null,
                        "alarm": true,
                        "alarmTimes": ["30"],
                        "memo": "프로젝트 회의 시작",
                        "recommendedRoutines": null,
                        "isFinish": false
                    }
                ]
                """.data(using: .utf8)!
        case .createRoutine, .updateRoutine:
            return """
                {
                    "id": 1,
                    "title": "아침운동",
                    "category": "운동",
                    "isPublic": true,
                    "dateAndTime": "2024-07-09T07:30:00Z",
                    "isRepeating": true,
                    "isRepeatAllDay": false,
                    "repeatDays": ["월", "수", "금"],
                    "alarm": true,
                    "alarmTimes": ["60", "10"],
                    "memo": "아침에 일어나서 운동하기",
                    "recommendedRoutines": ["스트래칭 하기", "달리기"],
                    "isFinish": false
                }
                """.data(using: .utf8)!
        case .fetchRoutine:
            return """
                {
                    "id": 1,
                    "title": "아침운동",
                    "category": "운동",
                    "isPublic": true,
                    "dateAndTime": "2024-07-09T07:30:00Z",
                    "isRepeating": true,
                    "isRepeatAllDay": false,
                    "repeatDays": ["월", "수", "금"],
                    "alarm": true,
                    "alarmTimes": ["60", "10"],
                    "memo": "아침에 일어나서 운동하기",
                    "recommendedRoutines": ["스트래칭 하기", "달리기"],
                    "isFinish": false
                }
                """.data(using: .utf8)!
        case .deleteRoutine:
            return """
                {
                    "success": true
                }
                """.data(using: .utf8)!
        }
    }
}
