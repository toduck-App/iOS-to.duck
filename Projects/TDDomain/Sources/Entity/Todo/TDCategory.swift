public struct TDCategory: Hashable {
    public let colorHex: String
    public let imageName: String
    
    public init(
        colorHex: String,
        imageName: String
    ) {
        self.colorHex = colorHex
        self.imageName = imageName
    }
}

extension TDCategory: Equatable {
    public static func == (lhs: TDCategory, rhs: TDCategory) -> Bool {
        return lhs.colorHex == rhs.colorHex && lhs.imageName == rhs.imageName
    }
}
