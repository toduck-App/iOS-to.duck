//
//  RoutineTarget.swift
//  toduck
//
//  Created by 승재 on 7/9/24.
//

import Foundation
import Moya

enum RoutineTarget {
    case fetchRoutineList // 모든 루틴 조회
    case createRoutine(routine: Routine) // 루틴 생성
    case fetchRoutine(routineId: Int) // 특정 루틴 조회
    case updateRoutine(routineId: Int, routine: Routine) // 루틴 업데이트
    case deleteRoutine(routineId: Int) // 루틴 삭제
}

extension RoutineTarget: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }

    var path: String {
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

    var method: Moya.Method {
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

    var task: Moya.Task {
        switch self {
        case .fetchRoutineList,
             .fetchRoutine,
             .deleteRoutine:
            return .requestPlain
        case .createRoutine(let routine), .updateRoutine(_, let routine):
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
