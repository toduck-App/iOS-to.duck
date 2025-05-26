public enum PostCategory: Int, CaseIterable {
    case concentration = 1
    case memory = 2
    case mistake = 3
    case anxiety = 4
    case infomation = 5
    case normal = 6
    
    public var title: String {
        switch self {
        case .concentration: return "집중력"
        case .memory: return "기억력"
        case .mistake: return "실수"
        case .anxiety: return "불안"
        case .infomation: return "정보"
        case .normal: return "기타"
        }
    }
}
