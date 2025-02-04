import UIKit
import SnapKit
import Then

public final class ScheduleSegmentedControl: UISegmentedControl {
    public var selectedSegmentTextColor: UIColor = TDColor.Neutral.neutral800
    public var normalSegmentTextColor: UIColor = TDColor.Neutral.neutral500
    public var titleFont: UIFont = TDFont.boldBody3.font
    
    // MARK: - Initializers
    public override init(items: [Any]?) {
        super.init(items: items)
        setSegmentedControl()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setSegmentedControl()
    }
    
    // MARK: - Setup
    private func setSegmentedControl() {
        selectedSegmentIndex = 0
        setSegmentedImage()
        setSegmentedFont()
    }
    
    private func setSegmentedImage() {
        setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    private func setSegmentedFont() {
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: selectedSegmentTextColor,
            .font: titleFont
        ]
        setTitleTextAttributes(selectedAttributes, for: .selected)
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: normalSegmentTextColor,
            .font: titleFont
        ]
        setTitleTextAttributes(normalAttributes, for: .normal)
    }
}
