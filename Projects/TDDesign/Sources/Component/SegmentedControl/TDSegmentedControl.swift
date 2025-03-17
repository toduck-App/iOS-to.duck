import SnapKit
import UIKit

public final class TDSegmentedControl: UIControl {
    // MARK: - Properties
    
    public var items: [String] {
        didSet { setupSegments() }
    }
    
    public private(set) var selectedIndex: Int = 0 {
        didSet {
            updateSelectedIndex()
            sendActions(for: .valueChanged)
        }
    }
    
    public var indicatorForeGroundColor: UIColor {
        didSet { indicatorView.backgroundColor = indicatorForeGroundColor }
    }
    
    public var indicatorBackGroundColor: UIColor {
        didSet { backgroundColor = indicatorBackGroundColor }
    }
    
    public var selectedTextColor: UIColor
    public var normalTextColor: UIColor
    public var titleFont: UIFont
    
    // MARK: - UI Components
    
    private let stackView = UIStackView()
    private let indicatorView = UIView()
    private var buttons: [UIButton] = []
    
    // MARK: - Initialization
    
    public init(
        items: [String],
        indicatorForeGroundColor: UIColor = TDColor.Neutral.neutral800,
        indicatorBackGroundColor: UIColor = TDColor.baseWhite,
        selectedTextColor: UIColor = TDColor.Neutral.neutral800,
        normalTextColor: UIColor = TDColor.Neutral.neutral500,
        titleFont: UIFont = TDFont.boldHeader5.font
    ) {
        self.items = items
        self.indicatorForeGroundColor = indicatorForeGroundColor
        self.indicatorBackGroundColor = indicatorBackGroundColor
        self.selectedTextColor = selectedTextColor
        self.normalTextColor = normalTextColor
        self.titleFont = titleFont
        
        super.init(frame: .zero)
        
        setupViews()
        setupSegments()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        backgroundColor = indicatorBackGroundColor
        
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        indicatorView.backgroundColor = indicatorForeGroundColor
        addSubview(indicatorView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        indicatorView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(2)
        }
    }
    
    private func setupSegments() {
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        
        items.enumerated().forEach { index, title in
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(normalTextColor, for: .normal)
            button.setTitleColor(selectedTextColor, for: .selected)
            button.titleLabel?.font = titleFont
            button.tag = index
            button.addTarget(self, action: #selector(segmentTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }
        
        updateSelectedIndex()
    }
    
    // MARK: - Interaction Handling
    
    @objc
    private func segmentTapped(_ sender: UIButton) {
        selectedIndex = sender.tag
        sendActions(for: .valueChanged)
    }
    
    // MARK: - Update UI
    
    private func updateSelectedIndex() {
        buttons.enumerated().forEach { index, button in
            let isSelected = index == selectedIndex
            button.setTitleColor(isSelected ? selectedTextColor : normalTextColor, for: .normal)
            button.titleLabel?.font = titleFont
        }
        updateIndicatorPosition(animated: true)
    }
    
    private func updateIndicatorPosition(animated: Bool) {
        guard selectedIndex < buttons.count else { return }

        let selectedButton = buttons[selectedIndex]

        indicatorView.snp.remakeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(2)
            $0.width.equalTo(selectedButton)
            $0.leading.equalTo(selectedButton)
        }

        if animated {
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        } else {
            layoutIfNeeded()
        }
    }
    
    // MARK: - Public Methods
    
    /// 세그먼트 아이템을 동적으로 변경할 수 있도록 함
    public func setItems(_ items: [String]) {
        self.items = items
    }
    
    /// 색상 업데이트 메서드
    public func updateColors(
        indicator: UIColor,
        background: UIColor,
        selectedText: UIColor,
        normalText: UIColor
    ) {
        self.indicatorForeGroundColor = indicator
        self.indicatorBackGroundColor = background
        self.selectedTextColor = selectedText
        self.normalTextColor = normalText
        
        backgroundColor = background
        indicatorView.backgroundColor = indicator
        updateSelectedIndex()
    }
    
    public func updateIndicatorColor(
        foreground: UIColor,
        background: UIColor
    ) {
        self.indicatorForeGroundColor = foreground
        self.indicatorBackGroundColor = background
        indicatorView.backgroundColor = indicatorForeGroundColor
        backgroundColor = indicatorBackGroundColor
    }
    
    /// 폰트 업데이트 메서드
    public func updateFont(_ font: UIFont) {
        self.titleFont = font
        updateSelectedIndex()
    }
}
