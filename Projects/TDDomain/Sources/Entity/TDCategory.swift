public struct TDCategory {
    public let colorHex: String
    public let imageType: TDCategoryImageType
    
    public init(
        colorHex: String,
        imageType: TDCategoryImageType
    ) {
        self.colorHex = colorHex
        self.imageType = imageType
    }
}
