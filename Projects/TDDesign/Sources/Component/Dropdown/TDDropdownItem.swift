import UIKit

public struct TDDropdownItem {
    public let title: String
    public let leftImage: SelectableImage?
    public let rightImage: SelectableImage?
    
    public typealias SelectableImage = (defaultImage: UIImage, selectedImage: UIImage?)
    
    public init(
        title: String,
        leftImage: SelectableImage? = nil,
        rightImage: SelectableImage? = nil
    ) {
        self.title = title
        self.leftImage = leftImage
        self.rightImage = rightImage
    }
}
