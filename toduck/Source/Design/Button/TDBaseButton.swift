
import Foundation
import SnapKit
import UIKit

public class TDBaseButton: UIButton {
    var title: String
    var foregroundToduckColor: UIColor
    var backgroundToduckColor: UIColor

    var radius: CGFloat = 12
    var font: UIFont = TDFont.boldHeader3.font
    var inset: NSDirectionalEdgeInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
    var image: UIImage?

    public init(frame: CGRect = .zero,
                title: String = "",
                image: UIImage? = nil,
                backgroundColor: UIColor = TDColor.Primary.primary500,
                foregroundColor: UIColor = .white)
    {
        self.title = title
        self.image = image
        backgroundToduckColor = backgroundColor
        foregroundToduckColor = foregroundColor
        super.init(frame: frame)
        configurationUpdateHandler = buttonHandler
        configuration = config()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config() -> UIButton.Configuration {
        var cfg = UIButton.Configuration.plain()

        cfg.baseForegroundColor = foregroundToduckColor
        cfg.baseBackgroundColor = backgroundToduckColor

        cfg.attributedTitle = .init(title, attributes: AttributeContainer([.font: font]))
        cfg.contentInsets = inset
        cfg.titleAlignment = .center
        cfg.titleLineBreakMode = .byTruncatingTail
        cfg.background.cornerRadius = radius
        
        return cfg
    }

    func buttonHandler(_ button: UIButton) {
        switch button.state {
        case .disabled:
            var cfg: UIButton.Configuration? = button.configuration
            cfg?.background.backgroundColor = TDColor.Neutral.neutral300
            cfg?.baseForegroundColor = TDColor.Neutral.neutral500
            cfg?.background.strokeColor = .clear
            button.configuration = cfg
        default:
            var cfg: UIButton.Configuration? = button.configuration
            cfg?.background.backgroundColor = backgroundToduckColor
            cfg?.baseForegroundColor = foregroundToduckColor
            button.configuration = cfg
        }
    }

    func makeConstraints() {
        snp.updateConstraints {
            $0.height.equalTo(56)
        }
    }

    // MARK: - Radius

    func setRadius(radius: CGFloat) {
        self.radius = radius
        configuration = config()
    }

    // MARK: - Font

    func setFont(font: UIFont) {
        self.font = font
        configuration = config()
    }

    func setFont(toduckFont: TDFont) {
        setFont(font: toduckFont.font)
    }

    // MARK: - Inset

    func setInset(top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0) {
        inset = NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
        configuration = config()
    }

    func setInset(x: CGFloat = 0, y: CGFloat = 0) {
        setInset(top: y, leading: x, bottom: y, trailing: x)
    }

    func setInset(edges: CGFloat) {
        setInset(top: edges, leading: edges, bottom: edges, trailing: edges)
    }
}
