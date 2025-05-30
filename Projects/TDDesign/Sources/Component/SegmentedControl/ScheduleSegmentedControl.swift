import UIKit
import SnapKit
import Then

public final class ScheduleSegmentedControl: UISegmentedControl {
    private let selectedSegmentTextColor: UIColor = TDColor.Neutral.neutral800
    private let normalSegmentTextColor: UIColor = TDColor.Neutral.neutral500
    private let titleFont: UIFont = TDFont.boldHeader5.font
    
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
        setSegmentedFont()
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
