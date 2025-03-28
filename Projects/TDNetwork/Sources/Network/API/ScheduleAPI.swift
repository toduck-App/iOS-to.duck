import Foundation
import TDCore
import TDData
import TDDomain

public enum ScheduleAPI {
    case fetchSchedule(scheduleRecordId: Int) // 특정 일정 조회
    case fetchScheduleList(startDate: String, endDate: String) // 모든 일정 조회
    case moveTomorrowSchedule(scheduleId: Int) // 일정 내일로 이동
    case createSchedule(schedule: ScheduleRequestDTO) // 일정 생성
    case updateSchedule(scheduleId: Int, schedule: ScheduleRequestDTO) // 일정 업데이트
    case deleteSchedule(scheduleId: Int) // 일정 삭제
}

extension ScheduleAPI: MFTarget {
    public var baseURL: URL {
        URL(string: APIConstants.baseURL)!
    }
    
    public var path: String {
        switch self {
        case .fetchSchedule,
                .fetchScheduleList:
            "v1/schedules"
        case .moveTomorrowSchedule(let scheduleId):
            "v1/schedules/\(scheduleId)/move-tomorrow"
        case .createSchedule:
            "v1/schedules"
        case .updateSchedule(let scheduleId, _):
            "v1/schedules/\(scheduleId)"
        case .deleteSchedule(let scheduleId):
            "v1/schedules/\(scheduleId)"
        }
    }
    
    public var method: MFHTTPMethod {
        switch self {
        case .fetchSchedule,
                .fetchScheduleList:
                .get
        case .moveTomorrowSchedule,
                .createSchedule:
                .post
        case .updateSchedule:
                .put
        case .deleteSchedule:
                .delete
        }
    }
    
    public var queries: Parameters? {
        switch self {
        case .fetchSchedule(let scheduleRecordId):
            return ["scheduleRecordId": scheduleRecordId]
        case .fetchScheduleList(let startDate, let endDate):
            return ["startDate": startDate, "endDate": endDate]
            
        case .moveTomorrowSchedule,
                .createSchedule,
                .updateSchedule,
                .deleteSchedule:
            return nil
        }
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
                .requestParameters(parameters: [
                "title": schedule.title,
                "category": schedule.category,
                "color": schedule.color,
                "startDate": schedule.startDate,
                "endDate": schedule.endDate,
                "isAllDay": schedule.isAllDay,
                "time": schedule.time,
                "alarm": schedule.alarm,
                "daysOfWeek": schedule.daysOfWeek,
                "location": schedule.location,
                "memo": schedule.memo
            ])
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
