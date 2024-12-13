public struct TDCategory {
    public let color: TDCategoryColor
    public let imageType: TDCategoryImageType
    
    public init(
        color: TDCategoryColor,
        imageType: TDCategoryImageType
    ) {
        self.color = color
        self.imageType = imageType
    }
}
