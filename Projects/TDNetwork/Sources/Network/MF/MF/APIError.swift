public enum APIError: Int, Error, CustomStringConvertible {
    // MARK: - Auth 관련 에러 (HTTP Status: 401, 403)

    case invalidLoginIdOrPassword = 40101 // 아이디 또는 비밀번호가 일치하지 않습니다.
    case forbiddenAccessToken = 40102 // 토큰에 접근 권한이 없습니다.
    case emptyAccessToken = 40103 // 토큰이 포함되어 있지 않습니다.
    case expiredAccessToken = 40104 // 재 로그인이 필요합니다.
    case malformedToken = 40105 // 비정상적인 토큰입니다.
    case tamperedToken = 40106 // 서명이 조작된 토큰입니다.
    case unsupportedJWTToken = 40107 // 지원하지 않는 토큰입니다.
    case takenAwayToken = 40108 // 인증 불가, 관리자에게 문의하세요.
    case expiredRefreshToken = 40109 // 재 로그인이 필요합니다.
    case existsPhoneNumber = 40110 // 이미 가입된 전화번호입니다.
    case overMaxMessageCount = 40111 // 인증코드 요청 횟수를 초과하였습니다.
    case overMaxVerifiedCount = 40112 // 인증코드 확인 횟수를 초과하였습니다.
    case existsUserId = 40113 // 이미 가입된 아이디입니다.
    case notSendPhoneNumber = 40114 // 인증 요청이 보내지 않은 전화번호입니다.
    case invalidVerifiedCode = 40115 // 인증 코드가 일치하지 않습니다.
    case notVerifiedPhoneNumber = 40116 // 인증되지 않은 전화번호입니다.
    case existsEmail = 40117 // 이미 가입된 이메일입니다.
    case invalidIdToken = 40118 // 유효하지 않은 ID 토큰입니다.
    case abnormalIdToken = 40119 // 비정상적인 ID 토큰입니다.
    case notMatchedPublicKey = 40120 // 일치하는 공개키를 찾을 수 없습니다.
    
    // MARK: - User 관련 에러

    case notFoundUser = 40201 // 사용자를 찾을 수 없습니다.
    case invalidUserField = 40202 // 유효하지 않은 사용자 필드입니다.
    case cannotBlockSelf = 40203 // 자기 자신을 차단할 수 없습니다.
    case notFoundBlock = 40204 // 차단 정보를 찾을 수 없습니다.
    case alreadyBlocked = 40205 // 이미 차단된 사용자입니다.
    
    // MARK: - Social 관련 에러

    case notFoundSocialBoard = 40401 // 게시글을 찾을 수 없습니다.
    case unauthorizedAccessSocialBoard = 40402 // 게시글에 접근 권한이 없습니다.
    case notFoundSocialCategory = 40403 // 찾을 수 없는 카테고리가 포함되어 있습니다.
    case notFoundComment = 40404 // 해당 댓글을 찾을 수 없습니다.
    case unauthorizedAccessComment = 40405 // 해당 댓글에 접근 권한이 없습니다.
    case invalidCommentForBoard = 40406 // 해당 게시글에 댓글이 속하지 않습니다.
    case existsLike = 40407 // 이미 좋아요가 존재합니다.
    case notFoundLike = 40408 // 해당 좋아요를 찾을 수 없습니다.
    case unauthorizedAccessLike = 40409 // 해당 좋아요에 접근 권한이 없습니다.
    case invalidLikeForBoard = 40410 // 해당 게시글에 좋아요가 속하지 않습니다.
    case emptySocialCategoryList = 40411 // 카테고리 목록은 최소 1개의 항목을 포함해야 합니다.
    case blockedUserSocialAccess = 40412 // 차단된 사용자의 게시글에 접근할 수 없습니다.
    case alreadyReported = 40413 // 이미 신고된 게시글입니다.
    case cannotReportOwnPost = 40414 // 자신의 게시글은 신고할 수 없습니다.
    case existsCommentLike = 40415 // 이미 댓글에 좋아요를 눌렀습니다.
    case notFoundCommentLike = 40416 // 해당 댓글 좋아요를 찾을 수 없습니다.
    case invalidSearchKeyword = 40417 // 검색 키워드는 null일 수 없습니다.
    case notFoundParentComment = 40418 // 부모 댓글을 찾을 수 없습니다.
    case invalidParentComment = 40419 // 답글은 부모 댓글이 될 수 없습니다.
    
    // MARK: - Other 관련 에러

    case notFoundScheduleRecord = 43101 // 일정 기록을 찾을 수 없습니다.
    case notFoundSchedule = 43102 // 일정을 찾을 수 없습니다.
    case nonRepetitiveOneScheduleNotPeriodDelete = 43103 // 반복되지 않는 하루 일정은 기간 삭제가 불가능합니다.
    case notFoundResource = 49901 // 해당 경로를 찾을 수 없습니다.
    case methodForbidden = 49902 // 지원하지 않는 HTTP 메서드를 사용합니다.
    case invalidImageExtension = 49903 // 지원되지 않는 이미지 파일 확장자입니다.
    
    // MARK: - Routine 관련 에러

    case notFoundRoutine = 43201 // 권한이 없거나 존재하지 않는 루틴입니다.
    case routineInvalidDate = 43202 // 유효하지 않은 루틴 날짜입니다.
    case privateRoutine = 43203 // 비공개된 루틴입니다.
    
    // MARK: - 기타 (Not 4XXXX) 에러

    case validationError = 30001 // 유효성 검사 실패
    case voException = 30002 // 백엔드 내부 유효성 검사 실패
    case internalServerError = 50000 // 서버 내부 오류
    
    // MARK: - CustomStringConvertible

    public var description: String {
        switch self {
        // Auth 관련 에러
        case .invalidLoginIdOrPassword: "아이디 또는 비밀번호가 일치하지 않습니다."
        case .forbiddenAccessToken: "토큰에 접근 권한이 없습니다."
        case .emptyAccessToken: "토큰이 포함되어 있지 않습니다."
        case .expiredAccessToken: "재 로그인이 필요합니다."
        case .malformedToken: "비정상적인 토큰입니다."
        case .tamperedToken: "서명이 조작된 토큰입니다."
        case .unsupportedJWTToken: "지원하지 않는 토큰입니다."
        case .takenAwayToken: "인증 불가, 관리자에게 문의하세요."
        case .expiredRefreshToken: "재 로그인이 필요합니다."
        case .existsPhoneNumber: "이미 가입된 전화번호입니다."
        case .overMaxMessageCount: "인증코드 요청 횟수를 초과하였습니다."
        case .overMaxVerifiedCount: "인증코드 확인 횟수를 초과하였습니다."
        case .existsUserId: "이미 가입된 아이디입니다."
        case .notSendPhoneNumber: "인증 요청이 보내지 않은 전화번호입니다."
        case .invalidVerifiedCode: "인증 코드가 일치하지 않습니다."
        case .notVerifiedPhoneNumber: "인증되지 않은 전화번호입니다."
        case .existsEmail: "이미 가입된 이메일입니다."
        case .invalidIdToken: "유효하지 않은 ID 토큰입니다."
        case .abnormalIdToken: "비정상적인 ID 토큰입니다."
        case .notMatchedPublicKey: "일치하는 공개키를 찾을 수 없습니다."
        // User 관련 에러
        case .notFoundUser: "사용자를 찾을 수 없습니다."
        case .invalidUserField: "유효하지 않은 사용자 필드입니다."
        case .cannotBlockSelf: "자기 자신을 차단할 수 없습니다."
        case .notFoundBlock: "차단 정보를 찾을 수 없습니다."
        case .alreadyBlocked: "이미 차단된 사용자입니다."
        // Social 관련 에러
        case .notFoundSocialBoard: "게시글을 찾을 수 없습니다."
        case .unauthorizedAccessSocialBoard: "게시글에 접근 권한이 없습니다."
        case .notFoundSocialCategory: "찾을 수 없는 카테고리가 포함되어 있습니다."
        case .notFoundComment: "해당 댓글을 찾을 수 없습니다."
        case .unauthorizedAccessComment: "해당 댓글에 접근 권한이 없습니다."
        case .invalidCommentForBoard: "해당 게시글에 댓글이 속하지 않습니다."
        case .existsLike: "이미 좋아요가 존재합니다."
        case .notFoundLike: "해당 좋아요를 찾을 수 없습니다."
        case .unauthorizedAccessLike: "해당 좋아요에 접근 권한이 없습니다."
        case .invalidLikeForBoard: "해당 게시글에 좋아요가 속하지 않습니다."
        case .emptySocialCategoryList: "카테고리 목록은 최소 1개의 항목을 포함해야 합니다."
        case .blockedUserSocialAccess: "차단된 사용자의 게시글에 접근할 수 없습니다."
        case .alreadyReported: "이미 신고된 게시글입니다."
        case .cannotReportOwnPost: "자신의 게시글은 신고할 수 없습니다."
        case .existsCommentLike: "이미 댓글에 좋아요를 눌렀습니다."
        case .notFoundCommentLike: "해당 댓글 좋아요를 찾을 수 없습니다."
        case .invalidSearchKeyword: "검색 키워드는 null일 수 없습니다."
        case .notFoundParentComment: "부모 댓글을 찾을 수 없습니다."
        case .invalidParentComment: "답글은 부모 댓글이 될 수 없습니다."
        // Other 관련 에러
        case .notFoundScheduleRecord: "일정 기록을 찾을 수 없습니다."
        case .notFoundSchedule: "일정을 찾을 수 없습니다."
        case .nonRepetitiveOneScheduleNotPeriodDelete:
            "반복되지 않는 하루 일정은 기간 삭제가 불가능합니다."
        case .notFoundResource: "해당 경로를 찾을 수 없습니다."
        case .methodForbidden: "지원하지 않는 HTTP 메서드를 사용합니다."
        case .invalidImageExtension: "지원되지 않는 이미지 파일 확장자입니다."
        // Routine 관련 에러
        case .notFoundRoutine: "권한이 없거나 존재하지 않는 루틴입니다."
        case .routineInvalidDate: "유효하지 않은 루틴 날짜입니다."
        case .privateRoutine: "비공개된 루틴입니다."
        // 기타 (Not 4XXXX) 에러
        case .validationError: "유효성 검사 실패"
        case .voException: "백엔드 내부 유효성 검사 실패"
        case .internalServerError: "서버 내부 오류"
        }
    }
}
