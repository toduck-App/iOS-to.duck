import UIKit

/// 선택 상태를 가진 버튼을 나타내는 `TDSelectableButton` 클래스입니다.
public final class TDSelectableButton: TDBaseButton {
    // MARK: - Properties
    private var selectedBackgroundColor: UIColor
    private var selectedForegroundColor: UIColor
    private var deselectedBackgroundColor: UIColor
    private var deselectedForegroundColor: UIColor
    private let titleFont: UIFont
    private let radius: CGFloat
    public let identifier: String
    
    // MARK: - Initializer
    public init(
        title: String,
        backgroundColor: UIColor = TDColor.Neutral.neutral50,
        foregroundColor: UIColor = TDColor.Neutral.neutral800,
        selectedBackgroundColor: UIColor = TDColor.Primary.primary100,
        selectedForegroundColor: UIColor = TDColor.Primary.primary500,
        radius: CGFloat = 12,
        font: UIFont = TDFont.boldBody2.font
    ) {
        self.identifier = title
        self.selectedBackgroundColor = selectedBackgroundColor
        self.selectedForegroundColor = selectedForegroundColor
        self.deselectedBackgroundColor = backgroundColor
        self.deselectedForegroundColor = foregroundColor
        self.titleFont = font
        self.radius = radius
        super.init(
            title: title,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            radius: radius,
            font: font
        )
        setupSelectableHandler()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupSelectableHandler() {
        configurationUpdateHandler = { [weak self] button in
            guard let self = self else { return }
            var cfg = button.configuration ?? .plain()
            
            let bgColor = self.isSelected
                ? self.selectedBackgroundColor
                : self.deselectedBackgroundColor
            
            let fgColor = self.isSelected
                ? self.selectedForegroundColor
                : self.deselectedForegroundColor
            
            var bg = UIBackgroundConfiguration.clear()
            bg.backgroundColor = bgColor
            bg.cornerRadius = self.radius
            cfg.background = bg
            
            let nsAttributes: [NSAttributedString.Key: Any] = [
                .font: self.titleFont,
                .foregroundColor: fgColor
            ]
            let nsAttrTitle = NSAttributedString(string: self.identifier, attributes: nsAttributes)
            cfg.attributedTitle = AttributedString(nsAttrTitle)
            
            cfg.baseForegroundColor = fgColor
            if #available(iOS 15.0, *) {
                cfg.imageColorTransformer = UIConfigurationColorTransformer { _ in fgColor }
            }
            
            button.tintColor = fgColor
            button.configuration = cfg
        }
    }
    
    // MARK: - Override
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.hasDifferentColorAppearance(comparedTo: traitCollection) == true {
            setNeedsUpdateConfiguration()
        }
    }
    
    // MARK: - Public Methods
    public func setSelected(_ selected: Bool, animated: Bool = false) {
        guard selected != isSelected else { return }
        isSelected = selected
        if animated {
            UIView.transition(with: self, duration: 0.25, options: .transitionCrossDissolve) {
                self.setNeedsUpdateConfiguration()
            }
        } else {
            setNeedsUpdateConfiguration()
        }
    }
}

