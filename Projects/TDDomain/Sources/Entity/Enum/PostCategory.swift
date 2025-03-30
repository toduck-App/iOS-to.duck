public enum PostCategory: Int, CaseIterable {
    case concentration = 1
    case memory = 2
    case impulse = 3
    case anxiety = 4
    case sleep = 5
    case normal = 6
    
    public var title: String {
        switch self {
        case .concentration: return "집중력"
        case .memory: return "기억력"
        case .impulse: return "충동"
        case .anxiety: return "불안"
        case .sleep: return "수면"
        case .normal: return "일반"
        }
    }
}
