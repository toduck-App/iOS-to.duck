public struct SemVer: Comparable, Sendable {
    public let major: Int, minor: Int, patch: Int

    public init(_ string: String) {
        let comps = string.split(separator: ".", maxSplits: 2, omittingEmptySubsequences: false)
        func parse(_ s: Substring?) -> Int {
            guard let s = s else { return 0 }
            var digits = ""
            for ch in s { if ch.isNumber { digits.append(ch) } else { break } }
            return Int(digits) ?? 0
        }
        self.major = parse(comps.indices.contains(0) ? comps[0] : nil)
        self.minor = parse(comps.indices.contains(1) ? comps[1] : nil)
        self.patch = parse(comps.indices.contains(2) ? comps[2] : nil)
    }

    public static func < (lhs: SemVer, rhs: SemVer) -> Bool {
        if lhs.major != rhs.major { return lhs.major < rhs.major }
        if lhs.minor != rhs.minor { return lhs.minor < rhs.minor }
        return lhs.patch < rhs.patch
    }
}

public extension String {
    var asSemVer: SemVer { SemVer(self) }
}
