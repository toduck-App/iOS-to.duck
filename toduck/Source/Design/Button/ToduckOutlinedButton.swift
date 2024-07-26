import Foundation
import SnapKit
import UIKit

public final class TDOutlinedButton: TDBaseButton {
    public init(frame: CGRect = .zero, title: String) {
        super.init(frame: frame,
                   title: title,
                   backgroundColor: TDColor.Primary.primary50,
                   foregroundColor: TDColor.Primary.primary500)
        setFont(toduckFont: .mediumBody1)

        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func config() -> UIButton.Configuration {
        var cfg = super.config()
        cfg.background.cornerRadius = 8
        cfg.background.strokeWidth = 1
        cfg.background.strokeColor = foregroundToduckColor
        return cfg
    }

    override func makeConstraints() {
        snp.updateConstraints {
            $0.height.equalTo(57)
        }
    }

    override public var isSelected: Bool {
        didSet {
            var cfg: UIButton.Configuration? = configuration
            if isSelected {
                cfg?.baseBackgroundColor = backgroundToduckColor
                cfg?.baseForegroundColor = foregroundToduckColor
                cfg?.background.strokeWidth = 1
            } else {
                cfg?.baseBackgroundColor = TDColor.Neutral.neutral50
                cfg?.baseForegroundColor = TDColor.Neutral.neutral600
                cfg?.background.strokeWidth = 0
            }

            configuration = cfg
        }
    }

    @objc
    func buttonTapped() {
        isSelected.toggle()
        print("buttonTapped")
    }

    override func buttonHandler(_ button: UIButton) {
        switch button.state {
        case .selected:
            break

        case .disabled:
            var cfg: UIButton.Configuration? = button.configuration
            cfg?.baseBackgroundColor = TDColor.Neutral.neutral50
            cfg?.baseForegroundColor = TDColor.Neutral.neutral600
            cfg?.background.strokeWidth = 0
            cfg?.background.backgroundColor = TDColor.Neutral.neutral50
            button.configuration = cfg

        case .normal:
            print("normal")
            //button.configuration = config()

        default:
            break
        }
    }
}
