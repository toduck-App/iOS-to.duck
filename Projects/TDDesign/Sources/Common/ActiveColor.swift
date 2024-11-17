import UIKit

public struct ActiveColor {
    public let activeColor: UIColor
    public let inActiveColor: UIColor
    
    public init(
        activeColor: UIColor,
        inActiveColor: UIColor
    ) {
        self.activeColor = activeColor
        self.inActiveColor = inActiveColor
    }
}
