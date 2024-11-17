import UIKit

public struct TDDropdownItem {
    public let title: String
    public let leftImage: UIImage?
    public let rightImage: UIImage?
    
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
