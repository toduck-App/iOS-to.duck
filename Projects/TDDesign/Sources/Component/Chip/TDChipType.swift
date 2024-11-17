import UIKit

public struct TDChipType {
    public var backgroundColor: ActiveColor
    public var fontColor: ActiveColor
    public var cornerRadius: CGFloat
    public var height: CGFloat
    public var borderColor = ActiveColor(activeColor: .clear, inActiveColor: TDColor.Neutral.neutral200)
    
    public init(
        backgroundColor: ActiveColor,
        fontColor: ActiveColor,
        cornerRadius: CGFloat,
        height: CGFloat
    ) {
        self.backgroundColor = backgroundColor
        self.fontColor = fontColor
        self.cornerRadius = cornerRadius
        self.height = height
    }
}
