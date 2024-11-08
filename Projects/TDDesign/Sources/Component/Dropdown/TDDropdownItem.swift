import UIKit

public struct TDDropdownItem {
    public var title: String
    public var leftImage: UIImage? = nil
    public var rightImage: UIImage? = nil
    
    public init(
        title: String,
        leftImage: UIImage? = nil,
        rightImage: UIImage? = nil
    ) {
        self.title = title
        self.leftImage = leftImage
        self.rightImage = rightImage
    }
}
