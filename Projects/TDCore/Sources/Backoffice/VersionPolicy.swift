public enum VersionPolicy: String, CaseIterable {
    case force
    case recommend
    case none

    /// 서버/외부에서 들어온 문자열을 받아 케이스로 매핑 (대소문자/앞뒤 공백 무시)
    public init(name: String) {
        let key = name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        self = VersionPolicy(rawValue: key) ?? .none
    }
}
