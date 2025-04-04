import Foundation
import TDData
import TDCore
import TDDomain

public enum DiaryAPI {
    case fetchDiaryList(year: Int, month: Int) // 다이어리 리스트 조회
    case addDiary(diary: DiaryPostRequestDTO) // 다이어리 추가
    case updateDiary(id: DiaryPatchRequestDTO) // 다이어리 업데이트
    case deleteDiary(id: Int) // 다이어리 삭제
    case compareDiaryCount(year: Int, month: Int) // 특정 연월과 전월의 일기 개수를 비교
}

extension DiaryAPI: MFTarget {
    public var baseURL: URL {
        URL(string: APIConstants.baseURL)!
    }
    
    public var path: String {
        switch self {
        case .fetchDiaryList:
            "v1/diary"
        case .addDiary:
            "v1/diary"
        case .updateDiary(let diary):
            "v1/diary/\(diary.id)"
        case .deleteDiary(let id):
            "v1/diary/\(id)"
        case .compareDiaryCount:
            "v1/diary/count"
        }
    }
    
    public var method: MFHTTPMethod {
        switch self {
        case .fetchDiaryList:
                .get
        case .addDiary:
                .post
        case .updateDiary:
                .patch
        case .deleteDiary:
                .delete
        case .compareDiaryCount:
                .get
        }
    }
    
    public var queries: Parameters? {
        switch self {
        case .deleteDiary, .addDiary, .updateDiary:
            return nil
        case .fetchDiaryList(let year, let month):
            return ["year": year, "month": month]
        case .compareDiaryCount(let year, let month):
            return ["year": year, "month": month]
        }
    }
    
    public var task: MFTask {
        switch self {
        case .fetchDiaryList, .deleteDiary, .compareDiaryCount:
                .requestPlain
        case .addDiary(let diary):
                .requestParameters(parameters:
                    [
                        "date": diary.date,
                        "emotion": diary.emotion,
                        "title": diary.title,
                        "memo": diary.memo,
                        "diaryImageUrls": diary.diaryImageUrls
                    ]
                )
        case .updateDiary(let id):
            .requestParameters(parameters:
                [
                    "isChangeEmotion": id.isChangeEmotion,
                    "emotion": id.emotion,
                    "title": id.title,
                    "memo": id.memo,
                    "diaryImageUrls": id.diaryImageUrls
                ]
            )
        }
    }
    
    public var headers: MFHeaders? {
        let headers: MFHeaders = [
            .contentType("application/json"),
            .authorization(bearerToken: TDTokenManager.shared.accessToken ?? "")
        ]
        return headers
    }
}
