import UIKit

public struct TDChipItem {
    public var title: String
    public var leftImage: TDChipIcon? = nil
    public var rightImage: TDChipIcon? = nil
    
    public init(
        title: String,
        leftImage: TDChipIcon? = nil,
        rightImage: TDChipIcon? = nil
    ) {
        self.title = title
        self.leftImage = leftImage
        self.rightImage = rightImage
    }
}

public struct TDChipIcon {
    public var image: UIImage
    public var activeColor: UIColor
    public var inActiveColor: UIColor
    
    public init(image: UIImage, activeColor: UIColor, inActiveColor: UIColor) {
        self.image = image.withRenderingMode(.alwaysTemplate)
        self.activeColor = activeColor
        self.inActiveColor = inActiveColor
    }
}
