public enum ReportType: String, CaseIterable {
    case unrelated = "NOT_RELATED_TO_SERVICE"
    case personalInfo = "PRIVACY_RISK"
    case advertisement = "COMMERCIAL_ADVERTISEMENT"
    case inappropriate = "INAPPROPRIATE_CONTENT"
    case custom = "OTHER"
    
    
    public var title: String {
        switch self {
        case .unrelated:
            "서비스와 관련 없는 내용"
        case .personalInfo:
            "개인정보 유출 위험"
        case .advertisement:
            "상업적 광고 및 홍보글"
        case .inappropriate:
            "욕설/비하/음란성 등 부적절한 내용"
        case .custom:
            "기타 (직접 입력)"
        }
    }
    
    public var subTitle: String {
        switch self {
        case .unrelated:
            "서비스와 관련 없는 내용이에요"
        case .personalInfo:
            "개인정보 유출 위험이 있는 내용이에요"
        case .advertisement:
            "상업적 광고 및, 홍보글이 의심되는 내용이에요"
        case .inappropriate:
            "욕설/비하/음란성 등 부적절한 내용이에요"
        case .custom:
            "기타 (직접 입력)"
        }
    }
}
