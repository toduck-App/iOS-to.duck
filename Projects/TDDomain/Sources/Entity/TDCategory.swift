public struct TDCategory {
    public let colorType: TDCategoryColor
    public let imageType: TDCategoryImageType
    
    public init(
        colorType: TDCategoryColor,
        imageType: TDCategoryImageType
    ) {
        self.colorType = colorType
        self.imageType = imageType
    }
}
