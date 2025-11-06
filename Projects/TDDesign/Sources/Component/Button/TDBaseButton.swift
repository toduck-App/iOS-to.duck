import UIKit

public class TDBaseButton: UIButton {
    // MARK: - Properties
    private var title: String = ""
    private var image: UIImage? = nil
    private var radius: CGFloat = 12
    private var inset: NSDirectionalEdgeInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
    private var font: UIFont = TDFont.boldHeader3.font
    var foregroundToduckColor: UIColor = TDColor.baseWhite
    var backgroundToduckColor: UIColor = TDColor.Primary.primary500
    
    // MARK: - Initializer
    public init(
        title: String = "",
        image: UIImage? = nil,
        backgroundColor: UIColor = TDColor.Primary.primary500,
        foregroundColor: UIColor = .white,
        radius: CGFloat = 12,
        font: UIFont = TDFont.boldHeader3.font,
        inset: NSDirectionalEdgeInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
    ) {
        self.title = title
        self.image = image
        self.backgroundToduckColor = backgroundColor
        self.foregroundToduckColor = foregroundColor
        self.radius = radius
        self.font = font
        self.inset = inset
        super.init(frame: .zero)
        
        setupButton()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Button
    private func setupButton() {
        layer.borderWidth = 0
        var config = UIButton.Configuration.plain()
        config.title = title
        config.contentInsets = inset
        config.imagePlacement = .leading
        config.imagePadding = 4
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = self.font
            return outgoing
        }
        config.cornerStyle = .fixed

        if let image = image {
            config.image = image.withRenderingMode(.alwaysTemplate)
        }
        
        self.configuration = config
        layer.masksToBounds = false

        configurationUpdateHandler = { [weak self] button in
            guard let self = self else { return }
            var cfg = button.configuration ?? .plain()

            let bgColor: UIColor
            let fgColor: UIColor

            if !button.isEnabled {
                bgColor = TDColor.Neutral.neutral100
                fgColor = TDColor.Neutral.neutral500
            } else if button.isSelected {
                bgColor = self.backgroundToduckColor
                fgColor = self.foregroundToduckColor
            } else {
                bgColor = self.backgroundToduckColor
                fgColor = self.foregroundToduckColor
            }
            
            var bg = UIBackgroundConfiguration.clear()
            bg.backgroundColor = bgColor
            bg.cornerRadius = self.radius
            cfg.background = bg
            button.layer.cornerRadius = self.radius
            button.layer.masksToBounds = true

            var attrs = AttributeContainer()
            attrs.font = self.font
            attrs.foregroundColor = fgColor
            cfg.attributedTitle = AttributedString(self.title, attributes: attrs)

            cfg.baseForegroundColor = fgColor
            if #available(iOS 15.0, *) {
                cfg.imageColorTransformer = UIConfigurationColorTransformer { _ in fgColor }
            }

            cfg.contentInsets = self.inset
            button.tintColor = fgColor
            button.configuration = cfg
        }

    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.hasDifferentColorAppearance(comparedTo: traitCollection) == true {
            setNeedsUpdateConfiguration()
        }
    }
    
    // MARK: - Public Methods
    /// 버튼의 배경색을 설정합니다.
    public func updateBackgroundColor(backgroundColor: UIColor, foregroundColor: UIColor) {
        self.backgroundToduckColor = backgroundColor
        self.foregroundToduckColor = foregroundColor
        
        if let originalImage = image {
            image = originalImage.withRenderingMode(.alwaysTemplate)
        }
        setNeedsUpdateConfiguration()
    }
    
    /// 버튼의 `cornerRadius`를 설정합니다.
    public func setRadius(_ radius: CGFloat) {
        self.radius = radius
        setNeedsUpdateConfiguration()
    }
    
    /// 버튼의 `font`를 설정합니다.
    public func setFont(_ font: UIFont) {
        self.font = font
        setNeedsUpdateConfiguration()
    }
    
    /// 버튼의 `inset`을 설정합니다.
    public func setInset(top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0) {
        inset = NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
        setNeedsUpdateConfiguration()
    }
    
    /// 버튼에 그림자를 추가합니다.
    public func setShadow() {
        layer.shadowColor = UIColor(white: 0, alpha: 0.16).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 10
        layer.shadowOffset = .zero
    }
    
    /// 버튼의 텍스트를 변경합니다.
    public func updateTitle(_ newTitle: String) {
        self.title = newTitle
        setNeedsUpdateConfiguration()
    }
}

extension TDBaseButton {
    // MARK: - Convenience Initializers

    /// 텍스트 전용 버튼
    public convenience init(
        title: String,
        backgroundColor: UIColor = TDColor.Primary.primary500,
        foregroundColor: UIColor = .white,
        font: UIFont = TDFont.boldHeader3.font,
        radius: CGFloat = 12
    ) {
        self.init(
            title: title,
            image: nil,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            radius: radius,
            font: font
        )
    }

    /// 이미지 전용 버튼
    public convenience init(
        image: UIImage,
        backgroundColor: UIColor = TDColor.Primary.primary500,
        radius: CGFloat = 12
    ) {
        self.init(
            title: "",
            image: image,
            backgroundColor: backgroundColor,
            foregroundColor: .white,
            radius: radius,
            font: UIFont.systemFont(ofSize: 12)
        )
    }
}
