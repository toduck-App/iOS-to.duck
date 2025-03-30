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
        didSet { indicatorForegroundView.backgroundColor = indicatorForeGroundColor }
    }
    
    public var indicatorBackGroundColor: UIColor {
        didSet { indicatorBackgroundView.backgroundColor = indicatorBackGroundColor }
    }
    
    public var selectedTextColor: UIColor
    public var normalTextColor: UIColor
    public var titleFont: UIFont
    
    // MARK: - UI Components
    
    private let stackView = UIStackView()
    private let indicatorForegroundView = UIView()
    private let indicatorBackgroundView = UIView()
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
        
        configureView()
        setupLayout()
        setupSegments()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Setup
    
    private func configureView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        indicatorBackgroundView.backgroundColor = indicatorBackGroundColor
        indicatorForegroundView.backgroundColor = indicatorForeGroundColor
        
        addSubview(indicatorBackgroundView)
        addSubview(stackView)
        addSubview(indicatorForegroundView)
    }
    
    private func setupLayout() {
        indicatorBackgroundView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(2)
            $0.leading.trailing.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        indicatorForegroundView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(2)
        }
    }
    
    private func setupSegments() {
        clearSegments()
        
        items.enumerated().forEach { index, title in
            let button = createSegmentButton(title: title, index: index)
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }
        
        updateSelectedIndex()
    }
    
    private func clearSegments() {
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
    }
    
    private func createSegmentButton(title: String, index: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(normalTextColor, for: .normal)
        button.setTitleColor(selectedTextColor, for: .selected)
        button.titleLabel?.font = titleFont
        button.tag = index
        button.addTarget(self, action: #selector(segmentTapped(_:)), for: .touchUpInside)
        return button
    }
    
    // MARK: - Interaction Handling
    
    @objc
    private func segmentTapped(_ sender: UIButton) {
        selectedIndex = sender.tag
    }
    
    // MARK: - UI Updates
    
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
        
        indicatorForegroundView.snp.remakeConstraints {
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
    
    public func setItems(_ items: [String]) {
        self.items = items
    }
    
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
        indicatorForegroundView.backgroundColor = indicator
        updateSelectedIndex()
    }
    
    public func updateIndicatorColor(
        foreground: UIColor,
        background: UIColor
    ) {
        self.indicatorForeGroundColor = foreground
        self.indicatorBackGroundColor = background
        indicatorForegroundView.backgroundColor = indicatorForeGroundColor
        backgroundColor = indicatorBackGroundColor
    }
    
    public func updateFont(_ font: UIFont) {
        self.titleFont = font
        updateSelectedIndex()
    }
}
