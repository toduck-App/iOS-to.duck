//
//  DiaryAPI.swift
//  TDNetwork
//
//  Created by 디해 on 1/22/25.
//

import Foundation
import TDDomain

public enum DiaryAPI {
    case fetchDiary(id: Int) // 특정 다이어리 조회
    case fetchDiaryList(from: Date, to: Date) // 다이어리 리스트 조회
    case addDiary(diary: Diary) // 다이어리 추가
    case updateDiary(diary: Diary) // 다이어리 업데이트
    case deleteDiary(id: Int) // 다이어리 삭제
}

extension DiaryAPI: MFTarget {
    public var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    public var path: String {
        switch self {
        case .fetchDiary(let id):
            return "/diary/\(id)"
        case .fetchDiaryList:
            return "/diary"
        case .addDiary:
            return "/diary"
        case .updateDiary(let diary):
            return "/diary/\(diary.id)"
        case .deleteDiary(let id):
            return "/diary/\(id)"
        }
    }
    
    public var method: MFHTTPMethod {
        switch self {
        case .fetchDiary, .fetchDiaryList:
            return .get
        case .addDiary:
            return .post
        case .updateDiary:
            return .put
        case .deleteDiary:
            return .delete
        }
    }
    
    public var queries: Parameters? {
        switch self {
        case .fetchDiary, .deleteDiary, .addDiary, .updateDiary:
            return nil
        case .fetchDiaryList(let from, let to):
            let dateFormatter = ISO8601DateFormatter()
            let queries: [String: String] = [
                "from": dateFormatter.string(from: from),
                "to": dateFormatter.string(from: to)
            ]
            return queries
        }
    }
    
    public var task: MFTask {
        .requestPlain
    }
    
    public var headers: MFHeaders? {
        let headers: MFHeaders = [
            .contentType("application/json")
        ]
        return headers
    }
}
