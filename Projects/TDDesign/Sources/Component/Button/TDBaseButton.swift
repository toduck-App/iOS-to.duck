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
        font: UIFont = TDFont.boldHeader3.font
    ) {
        self.title = title
        self.image = image
        self.backgroundToduckColor = backgroundColor
        self.foregroundToduckColor = foregroundColor
        self.radius = radius
        self.font = font
        super.init(frame: .zero)
        
        setupButton()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Button
    private func setupButton() {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseBackgroundColor = backgroundToduckColor
        config.baseForegroundColor = foregroundToduckColor
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = self.font
            return outgoing
        }
        config.contentInsets = inset
        config.imagePlacement = .leading
        config.imagePadding = 4
        
        if let image = image {
            config.image = image.withRenderingMode(.alwaysTemplate)
        }
        
        self.configuration = config
        
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    // MARK: - State Management
    override
    public var isEnabled: Bool {
        didSet {
            if isEnabled {
                configuration?.baseBackgroundColor = backgroundToduckColor
                configuration?.baseForegroundColor = foregroundToduckColor
                layer.borderWidth = 1
            } else {
                configuration?.baseBackgroundColor = TDColor.Neutral.neutral100
                configuration?.baseForegroundColor = TDColor.Neutral.neutral500
                layer.borderWidth = 0
            }
        }
    }
    
    
    // MARK: - Public Methods
    
    /// 버튼의 `cornerRadius`를 설정합니다.
    public func setRadius(_ radius: CGFloat) {
        self.radius = radius
        layer.cornerRadius = radius
    }
    
    /// 버튼의 `font`를 설정합니다.
    public func setFont(_ font: UIFont) {
        self.font = font
        setupButton()
    }
    
    /// 버튼의 `inset`을 설정합니다.
    public func setInset(top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0) {
        inset = NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
        setupButton()
    }
    
    /// 버튼에 그림자를 추가합니다.
    public func setShadow() {
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.16).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 0)
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
