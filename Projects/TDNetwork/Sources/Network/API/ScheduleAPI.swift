import Foundation
import TDCore
import TDData
import TDDomain

public enum ScheduleAPI {
    case createSchedule(schedule: ScheduleRequestDTO) // 일정 생성
    case finishSchedule(scheduleId: Int, isComplete: Bool, queryDate: String) // 일정 완료 처리
    case fetchScheduleList(startDate: String, endDate: String) // 모든 일정 조회
    case moveTomorrowSchedule(scheduleId: Int) // 일정 내일로 이동
    case updateSchedule(schedule: ScheduleUpdateRequestDTO) // 일정 업데이트
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
        case .moveTomorrowSchedule(let scheduleId):
            "v1/schedules/\(scheduleId)/move-tomorrow"
        case .updateSchedule:
            "v1/schedules"
        case .deleteSchedule(let scheduleId):
            "v1/schedules/\(scheduleId)"
        }
    }
    
    public var method: MFHTTPMethod {
        switch self {
        case .fetchScheduleList:
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
        case .fetchScheduleList:
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
            
        case .createSchedule(let schedule):
                .requestParameters(parameters: [
                "title": schedule.title,
                "category": schedule.category,
                "color": schedule.color,
                "startDate": schedule.startDate,
                "endDate": schedule.endDate,
                "isAllDay": schedule.isAllDay,
                "time": schedule.time as Any,
                "alarm": schedule.alarm as Any,
                "daysOfWeek": schedule.daysOfWeek as Any,
                "location": schedule.location as Any,
                "memo": schedule.memo as Any
            ])
            
        case .updateSchedule(let schedule):
            .requestParameters(parameters: [
                "scheduleId": schedule.scheduleId,
                "isOneDayDeleted": schedule.isOneDayDeleted,
                "queryDate": schedule.queryDate,
                "scheduleData": [
                    "title": schedule.scheduleData.title,
                    "category": schedule.scheduleData.category,
                    "color": schedule.scheduleData.color,
                    "startDate": schedule.scheduleData.startDate,
                    "endDate": schedule.scheduleData.endDate,
                    "isAllDay": schedule.scheduleData.isAllDay,
                    "time": schedule.scheduleData.time as Any,
                    "alarm": schedule.scheduleData.alarm as Any,
                    "daysOfWeek": schedule.scheduleData.daysOfWeek as Any,
                    "location": schedule.scheduleData.location as Any,
                    "memo": schedule.scheduleData.memo as Any
                ]
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
