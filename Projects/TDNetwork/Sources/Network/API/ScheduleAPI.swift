import Foundation
import TDCore
import TDData
import TDDomain

public enum ScheduleAPI {
    case createSchedule(schedule: ScheduleRequestDTO) // 일정 생성
    case finishSchedule(scheduleId: Int, isComplete: Bool, queryDate: String) // 일정 완료 처리
    case fetchScheduleDetail(scheduleRecordId: Int) // 특정 일정 조회
    case fetchScheduleList(startDate: String, endDate: String) // 모든 일정 조회
    case moveTomorrowSchedule(scheduleId: Int) // 일정 내일로 이동
    case updateSchedule(scheduleId: Int, schedule: ScheduleRequestDTO) // 일정 업데이트
    case deleteSchedule(scheduleId: Int) // 일정 삭제
}

extension ScheduleAPI: MFTarget {
    public var baseURL: URL {
        URL(string: APIConstants.baseURL)!
    }
    
    public var path: String {
        switch self {
        case .createSchedule:
            "v1/schedules"
        case .finishSchedule:
            "v1/schedules/is-complete"
        case .fetchScheduleList:
            "v1/schedules"
        case .fetchScheduleDetail(let scheduleRecordId):
            "v1/schedules/\(scheduleRecordId)"
        case .moveTomorrowSchedule(let scheduleId):
            "v1/schedules/\(scheduleId)/move-tomorrow"
        case .updateSchedule(let scheduleId, _):
            "v1/schedules/\(scheduleId)"
        case .deleteSchedule(let scheduleId):
            "v1/schedules/\(scheduleId)"
        }
    }
    
    public var method: MFHTTPMethod {
        switch self {
        case .fetchScheduleDetail,
                .fetchScheduleList:
                .get
        case .moveTomorrowSchedule,
                .createSchedule,
                .finishSchedule:
                .post
        case .updateSchedule:
                .put
        case .deleteSchedule:
                .delete
        }
    }
    
    public var queries: Parameters? {
        switch self {
        case .fetchScheduleDetail(let scheduleRecordId):
            return ["scheduleRecordId": scheduleRecordId]
        case .fetchScheduleList(let startDate, let endDate):
            return ["startDate": startDate, "endDate": endDate]
            
        case .moveTomorrowSchedule,
                .createSchedule,
                .updateSchedule,
                .deleteSchedule,
                .finishSchedule:
            return nil
        }
    }
    
    public var task: MFTask {
        switch self {
        case .fetchScheduleDetail,
                .fetchScheduleList:
                .requestPlain
            
        case .moveTomorrowSchedule,
                .deleteSchedule:
                .requestPlain
            
        case .finishSchedule(let scheduleId, let isComplete, let queryDate):
            .requestParameters(parameters: [
                "scheduleId": scheduleId,
                "isComplete": isComplete,
                "queryDate": queryDate
            ])
            
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
        return jsonHeaders
    }
}
