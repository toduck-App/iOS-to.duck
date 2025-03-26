import Foundation
import TDCore
import TDDomain

public enum ScheduleAPI {
    case fetchSchedule(scheduleId: Int) // 특정 일정 조회
    case fetchScheduleList // 모든 일정 조회
    case moveTomorrowSchedule(scheduleId: Int) // 일정 내일로 이동
    case createSchedule(schedule: Schedule) // 일정 생성
    case updateSchedule(scheduleId: Int, schedule: Schedule) // 일정 업데이트
    case deleteSchedule(scheduleId: Int) // 일정 삭제
}

extension ScheduleAPI: MFTarget {
    public var baseURL: URL {
        URL(string: APIConstants.baseURL)!
    }
    
    public var path: String {
        switch self {
        case .fetchSchedule(let scheduleId):
            "/schedules/\(scheduleId)"
        case .fetchScheduleList:
            "/schedules"
        case .moveTomorrowSchedule(let scheduleId):
            "/schedules/\(scheduleId)/move-tomorrow"
        case .createSchedule:
            "/schedules"
        case .updateSchedule(let scheduleId, _):
            "/schedules/\(scheduleId)"
        case .deleteSchedule(let scheduleId):
            "/schedules/\(scheduleId)"
        }
    }
    
    public var method: MFHTTPMethod {
        switch self {
        case .fetchSchedule,
             .fetchScheduleList:
            .get
        case .moveTomorrowSchedule,
             .createSchedule,
             .updateSchedule:
            .post
        case .deleteSchedule:
            .delete
        }
    }
    
    public var queries: Parameters? {
        // TODO: - API에 따라 이 부분도 구현되어야 합니다.
        nil
    }
    
    public var task: MFTask {
        // TODO: - 아직 구현 전?
        switch self {
        case .fetchSchedule,
             .fetchScheduleList:
            .requestPlain
            
        case .moveTomorrowSchedule,
             .deleteSchedule:
            .requestPlain
            
        case .createSchedule(let schedule),
             .updateSchedule(_, let schedule):
            .requestPlain
        }
    }
    
    public var headers: MFHeaders? {
        let jsonHeaders: MFHeaders = [
            .contentType("application/json"),
            .authorization(bearerToken: TDTokenManager.shared.accessToken ?? "")
        ]
        // TODO: - 나중에 회의 후 결정
        return jsonHeaders
    }
}

public extension ScheduleAPI {
    var sampleData: Data {
        switch self {
        case .fetchSchedule:
            """
            {
                "id": 1,
                "title": "회의",
                "categoryImage": "a",
                "dateAndTime": "2024-07-10T09:00:00Z",
                "isRepeating": true,
                "repeatDays": ["월", "수", "금"],
                "alarm": true,
                "alarmTimes": ["60", "30"],
                "place": "디스코드"
                "memo": "프로젝트 진행 상황 점검",
                "isFinish": false
            }
            """.data(using: .utf8)!
        case .fetchScheduleList:
            """
            [
                {
                    "id": 1,
                    "title": "회의",
                    "categoryImage": "a",
                    "dateAndTime": "2024-07-10T09:00:00Z",
                    "isRepeating": true,
                    "repeatDays": ["월", "수", "금"],
                    "alarm": true,
                    "alarmTimes": ["60", "30"],
                    "place": "디스코드",
                    "memo": "프로젝트 진행 상황 점검",
                    "isFinish": false
                },
                {
                    "id": 2,
                    "title": "운동",
                    "categoryImage": "a",
                    "dateAndTime": "2024-07-11T18:00:00Z",
                    "isRepeating": false,
                    "repeatDays": null,
                    "alarm": true,
                    "alarmTimes": ["10"],
                    "place": "헬스장",
                    "memo": "웨이트 운동 1회",
                    "isFinish": false
                }
            ]
            """.data(using: .utf8)!
        case .createSchedule, .updateSchedule:
            """
            {
                "id": 1,
                "title": "회의",
                "categoryImage": "a",
                "dateAndTime": "2024-07-10T09:00:00Z",
                "isRepeating": true,
                "repeatDays": ["월", "수", "금"],
                "alarm": true,
                "alarmTimes": ["60", "30"],
                "place": "디스코드",
                "memo": "프로젝트 진행 상황 점검",
                "isFinish": false
            }
            """.data(using: .utf8)!
        case .deleteSchedule:
            """
            {
                "success": true
            }
            """.data(using: .utf8)!
        case .moveTomorrowSchedule(scheduleId: let scheduleId):
            """
            {
                "success": true
            }
            """.data(using: .utf8)!
        }
    }
}
