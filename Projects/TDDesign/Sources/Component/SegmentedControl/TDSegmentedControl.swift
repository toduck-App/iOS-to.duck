import SnapKit
import Then
import UIKit

public final class TDSegmentedControl: UISegmentedControl {
    
    // MARK: - Properties
    
    public var indicatorForeGroundColor: UIColor
    public var indicatorBackGroundColor: UIColor
    public var selectedSegmentTextColor: UIColor
    public var normalSegmentTextColor: UIColor
    public var titleFont: UIFont

    private let underForeGroundLineView = UIView()
    private let underBackGroundLineView = UIView()

    // MARK: - Initializer
    
    public init(
        items: [Any]?,
        indicatorForeGroundColor: UIColor = TDColor.Neutral.neutral800,
        indicatorBackGroundColor: UIColor = TDColor.baseWhite,
        selectedTextColor: UIColor = TDColor.Neutral.neutral800,
        normalTextColor: UIColor = TDColor.Neutral.neutral500,
        titleFont: UIFont = TDFont.boldHeader5.font
    ) {
        self.indicatorForeGroundColor = indicatorForeGroundColor
        self.indicatorBackGroundColor = indicatorBackGroundColor
        self.selectedSegmentTextColor = selectedTextColor
        self.normalSegmentTextColor = normalTextColor
        self.titleFont = titleFont
        super.init(items: items)
        
        setupSegmentedControl()
    }
    
    public required init?(coder: NSCoder) {
        self.indicatorForeGroundColor = TDColor.Neutral.neutral800
        self.indicatorBackGroundColor = TDColor.baseWhite
        self.selectedSegmentTextColor = TDColor.Neutral.neutral800
        self.normalSegmentTextColor = TDColor.Neutral.neutral500
        self.titleFont = TDFont.boldHeader5.font
        super.init(coder: coder)
        
        setupSegmentedControl()
    }
    
    // MARK: - Setup Methods
    
    private func setupSegmentedControl() {
        selectedSegmentIndex = 0
        
        underBackGroundLineView.backgroundColor = indicatorBackGroundColor
        addSubview(underBackGroundLineView)

        underForeGroundLineView.backgroundColor = indicatorForeGroundColor
        addSubview(underForeGroundLineView)
        
        addAction(UIAction { [weak self] _ in
            self?.updateIndicatorPosition(animated: true)
        }, for: .valueChanged)
        
        setSegmentedImage()
        updateAppearance()
        layout()
    }
    
    /// 세그먼트 외형을 투명하게 설정
    private func setSegmentedImage() {
        setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    /// 폰트 & 색상 설정
    private func updateAppearance() {
        underForeGroundLineView.backgroundColor = indicatorForeGroundColor
        
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
    
    // MARK: - Indicator Layout

    private func layout() {
        underBackGroundLineView.snp.makeConstraints {
            $0.top.equalTo(self.snp.bottom).offset(-1)
            $0.height.equalTo(1)
            $0.width.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        underForeGroundLineView.snp.makeConstraints {
            $0.top.equalTo(self.snp.bottom).offset(-1)
            $0.height.equalTo(1.5)
            $0.width.equalTo(self.snp.width).dividedBy(self.numberOfSegments)
            $0.leading.equalTo(self.snp.leading)
        }
    }
    
    private func updateIndicatorPosition(animated: Bool) {
        let segmentWidth = frame.width / CGFloat(numberOfSegments)
        let leadingDistance = segmentWidth * CGFloat(selectedSegmentIndex)
        
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.underForeGroundLineView.snp.updateConstraints {
                    $0.leading.equalTo(self.snp.leading).offset(leadingDistance)
                }
                self.layoutIfNeeded()
            }
        } else {
            underForeGroundLineView.snp.updateConstraints {
                $0.leading.equalTo(self.snp.leading).offset(leadingDistance)
            }
            layoutIfNeeded()
        }
    }
    
    // MARK: - Public Methods
    
    /// 색상 업데이트 메서드
    public func updateColors(
        indicator: UIColor,
        selectedText: UIColor,
        normalText: UIColor
    ) {
        self.indicatorForeGroundColor = indicator
        self.selectedSegmentTextColor = selectedText
        self.normalSegmentTextColor = normalText
        updateAppearance()
    }
    
    /// 폰트 업데이트 메서드
    public func updateFont(_ font: UIFont) {
        self.titleFont = font
        updateAppearance()
    }
}
