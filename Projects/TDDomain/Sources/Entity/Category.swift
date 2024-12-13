public struct Category {
    public let color: CategoryColor
    public let imageType: CategoryImageType
    
    public init(
        color: CategoryColor,
        imageType: CategoryImageType
    ) {
        self.color = color
        self.imageType = imageType
    }
}
