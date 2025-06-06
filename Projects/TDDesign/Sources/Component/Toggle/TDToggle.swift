import UIKit
import Foundation
import SnapKit

public final class TDToggle: UISwitch {
    convenience init() {
        self.init(frame: .zero)
        configuration()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func configuration() {
        //TODO: fix color later
        self.onTintColor = TDColor.Primary.primary500
    }
}   
