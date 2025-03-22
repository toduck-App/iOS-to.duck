import Foundation
import TDCore
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
        URL(string: APIConstants.baseURL)!
    }
    
    public var path: String {
        switch self {
        case .fetchDiary(let id):
            "/diary/\(id)"
        case .fetchDiaryList:
            "/diary"
        case .addDiary:
            "/diary"
        case .updateDiary(let diary):
            "/diary/\(diary.id)"
        case .deleteDiary(let id):
            "/diary/\(id)"
        }
    }
    
    public var method: MFHTTPMethod {
        switch self {
        case .fetchDiary, .fetchDiaryList:
            .get
        case .addDiary:
            .post
        case .updateDiary:
            .put
        case .deleteDiary:
            .delete
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
            .contentType("application/json"),
            .authorization(bearerToken: TDTokenManager.shared.accessToken ?? "")
        ]
        return headers
    }
}
