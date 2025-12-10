import UIKit
import SnapKit
import TDDesign

extension UIView {
    static func dividedLine() -> UIView {
        let dividedLineView = UIView()
        dividedLineView.backgroundColor = TDColor.Neutral.neutral100
        dividedLineView.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        return dividedLineView
    }
    
    static func diviedHorizontalLine(color: UIColor) -> UIView {
        let dividedLineView = UIView()
        dividedLineView.backgroundColor = color
        dividedLineView.snp.makeConstraints {
            $0.width.equalTo(1)
        }
        
        return dividedLineView
    }
}
