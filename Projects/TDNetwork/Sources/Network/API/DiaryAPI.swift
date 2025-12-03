import Foundation
import TDData
import TDCore
import TDDomain

public enum DiaryAPI {
    case fetchDiaryList(yearMonth: String) // 다이어리 리스트 조회
    case createDiary(diary: DiaryPostRequestDTO) // 다이어리 추가
    case updateDiary(diary: DiaryPatchRequestDTO) // 다이어리 업데이트
    case deleteDiary(id: Int) // 다이어리 삭제
    case compareDiaryCount(yearMonth: String) // 특정 연월과 전월의 일기 개수를 비교
    case fetchStreak // 일기 스트릭 조회
    case connectKeyword(diary: DiaryKeywordConnectRequestDTO) // 다이어리와 키워드 연결
    case fetchUserKeywords
    case createUserKeyword(diary: UserKeywordDTO)
    case deleteUserKeywords(diary: UserKeywordDTO)
}

extension DiaryAPI: MFTarget {
    public var baseURL: URL {
        URL(string: APIConstants.baseURL)!
    }
    
    public var path: String {
        switch self {
        case .fetchDiaryList:
            "v1/diary"
        case .createDiary:
            "v1/diary"
        case .updateDiary(let diary):
            "v1/diary/\(diary.id)"
        case .deleteDiary(let id):
            "v1/diary/\(id)"
        case .compareDiaryCount:
            "v1/diary/count"
        case .fetchStreak:
            "v1/diary/streak"
        case .connectKeyword:
            "v1/diaryKeyword"
        case .fetchUserKeywords:
            "v1/user-keywords"
        case .createUserKeyword:
            "v1/user-keywords/create"
        case .deleteUserKeywords:
            "v1/user-keywords/delete"
        }
    }
    
    public var method: MFHTTPMethod {
        switch self {
        case .fetchDiaryList:
                .get
        case .createDiary:
                .post
        case .updateDiary:
                .patch
        case .deleteDiary:
                .delete
        case .compareDiaryCount:
                .get
        case .fetchStreak:
                .get
        case .connectKeyword:
                .post
        case .fetchUserKeywords:
                .get
        case .createUserKeyword:
                .post
        case .deleteUserKeywords:
                .delete
        }
    }
    
    public var queries: Parameters? {
        switch self {
        case .deleteDiary, .createDiary, .updateDiary, .fetchStreak, .connectKeyword, .fetchUserKeywords, .createUserKeyword, .deleteUserKeywords:
            return nil
        case .fetchDiaryList(let yearMonth):
            return ["yearMonth": yearMonth]
        case .compareDiaryCount(let yearMonth):
            return ["yearMonth": yearMonth]
        }
    }
    
    public var task: MFTask {
        switch self {
        case .fetchDiaryList, .deleteDiary, .compareDiaryCount, .fetchStreak, .fetchUserKeywords:
                .requestPlain
        case .createDiary(let diary):
                .requestParameters(parameters:
                    [
                        "date": diary.date,
                        "emotion": diary.emotion,
                        "title": diary.title,
                        "memo": diary.memo,
                        "diaryImageUrls": diary.diaryImageUrls
                    ]
                )
        case .updateDiary(let diary):
            .requestParameters(parameters:
                [
                    "isChangeEmotion": diary.isChangeEmotion,
                    "emotion": diary.emotion,
                    "title": diary.title,
                    "memo": diary.memo,
                    "diaryImageUrls": diary.diaryImageUrls
                ]
            )
        case .connectKeyword(let diary):
            .requestParameters(parameters:
                [
                    "diaryId": diary.diaryId,
                    "keywordIds": diary.keywordIds
                ]
           )
        case .createUserKeyword(let dto):
            .requestParameters(parameters: [
                "keywordCategory": dto.category.uppercased(),
                "keyword": dto.keyword
            ])
        case .deleteUserKeywords(let dto):
            .requestParameters(parameters: [
                "keywordCategory": dto.category.uppercased(),
                "keyword": dto.keyword
            ])
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
