//
//  ScheduleTarget.swift
//  toduck
//
//  Created by 승재 on 7/9/24.
//

import Foundation
import Moya

enum ScheduleTarget {
    case fetchSchedule(scheduleId: Int) // 특정 일정 조회
    case fetchScheduleList // 모든 일정 조회
    case moveTomorrowSchedule(scheduleId: Int) // 일정 내일로 이동
    case createSchedule(schedule: Schedule) // 일정 생성
    case updateSchedule(scheduleId: Int, schedule: Schedule) // 일정 업데이트
    case deleteSchedule(scheduleId: Int) // 일정 삭제
}

extension ScheduleTarget: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }

    var path: String {
        switch self {
        case .fetchSchedule(let scheduleId):
            return "/schedules/\(scheduleId)"
        case .fetchScheduleList:
            return "/schedules"
        case .moveTomorrowSchedule(let scheduleId):
            return "/schedules/\(scheduleId)/move-tomorrow"
        case .createSchedule:
            return "/schedules"
        case .updateSchedule(let scheduleId, _):
            return "/schedules/\(scheduleId)"
        case .deleteSchedule(let scheduleId):
            return "/schedules/\(scheduleId)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .fetchSchedule,
             .fetchScheduleList:
            return .get
        case .moveTomorrowSchedule, 
             .createSchedule,
             .updateSchedule:
            return .post
        case .deleteSchedule:
            return .delete
        }
    }

    var task: Moya.Task {
        switch self {
        case .fetchSchedule,
             .fetchScheduleList:
            return .requestPlain
        case .moveTomorrowSchedule,
             .deleteSchedule:
            return .requestPlain
        case .createSchedule(let schedule), 
             .updateSchedule(_, let schedule):
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        var headers: [String: String] = ["Content-Type": "application/json"]
// MARK: 나중에 토큰 관리 회의 후 결정
//        if let accessToken = TokenManager.shared.accessToken {
//            headers["Authorization"] = "Bearer \(accessToken)"
//        }
        return headers
    }
}
