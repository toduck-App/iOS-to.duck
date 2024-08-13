import Foundation
import UIKit

public final class TDBadge: UIView {
    //나중에 Extension으로 빼기
    enum Semantic {
        case primary
        case success
        case error
        case warning
        case info

        var backgroundColor: UIColor {
            switch self {
            case .primary:
                return TDColor.Primary.primary25
            case .success:
                return UIColor(red: 0.8, green: 0.9, blue: 0.8, alpha: 1.00)
            case .error:
                return UIColor(red: 1.00, green: 0.26, blue: 0.29, alpha: 0.10)
            case .warning:
                return UIColor(red: 0.96, green: 1.00, blue: 0.91, alpha: 1.00)
            case .info:
                return UIColor(red: 0.39, green: 0.56, blue: 0.97, alpha: 0.10)
            }
        }

        var foregroundColor: UIColor {
            switch self {
            case .primary:
                return TDColor.Primary.primary500
            case .success:
                return TDColor.Semantic.success
            case .error:
                return TDColor.Semantic.error
            case .warning:
                return TDColor.Semantic.warning
            case .info:
                return TDColor.Semantic.info
            }
        }
    }

    private var title: String!
    private var backgroundToduckColor: UIColor!
    private var foregroundToduckColor: UIColor!

    private var label: TDLabel!
    convenience init(badgeTitle: String, backgroundToduckColor: UIColor = TDColor.Primary.primary25, foregroundToduckColor: UIColor = TDColor.Primary.primary500) {
        self.init(frame: .zero)
        self.title = badgeTitle
        self.backgroundToduckColor = backgroundToduckColor
        self.foregroundToduckColor = foregroundToduckColor
        setupBadge()
        layout()
    }

    convenience init(semanticTitle: String, semantic: Semantic) {
        self.init(frame: .zero)
        self.title = semanticTitle
        self.backgroundToduckColor = semantic.backgroundColor
        self.foregroundToduckColor = semantic.foregroundColor

        setupSmenticBadge()
        layout(width: 46)
    }

    convenience init(colorTitle: String, colorPair: Int) {
        self.init(frame: .zero)
        self.title = colorTitle
        self.backgroundToduckColor = TDColor.ColorPair[colorPair]?.back
        self.foregroundToduckColor = TDColor.ColorPair[colorPair]?.text

        setupColorBadge()
        layout(width: 50, height: 13)

    }

    @available(*, deprecated, message: "Please use init(badgeTitle:backgroundToduckColor:foregroundToduckColor:) instead")
    convenience init(_ title: String, backgroundToduckColor: UIColor = TDColor.Primary.primary25, foregroundToduckColor: UIColor = TDColor.Primary.primary500) {
        self.init(badgeTitle: title, backgroundToduckColor: backgroundToduckColor, foregroundToduckColor: foregroundToduckColor)
    }

    func setupBadge() {
        label = TDLabel(labelText: title, toduckFont: .mediumCaption2, toduckColor: foregroundToduckColor)
        label.textAlignment = .center
        label.sizeToFit()
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        label.backgroundColor = backgroundToduckColor
        addSubview(label)
    }

    func setupSmenticBadge() {
        label = TDLabel(labelText: title, toduckFont: .mediumCaption2, toduckColor: foregroundToduckColor)
        label.textAlignment = .center
        label.sizeToFit()
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        label.backgroundColor = backgroundToduckColor
        addSubview(label)
    }

    func setupColorBadge() {
        label = TDLabel(labelText: title, toduckFont: .mediumCaption2, toduckColor: foregroundToduckColor)
        label.textAlignment = .left
        label.sizeToFit()
        label.layer.cornerRadius = 2
        label.layer.masksToBounds = true
        label.backgroundColor = backgroundToduckColor
        addSubview(label)
    }

    func layout(width: CGFloat = 54, height: CGFloat = 20) {
        label.snp.makeConstraints {
            $0.width.equalTo(width)
            $0.height.equalTo(height)
            $0.bottom.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
        }
    }


}
