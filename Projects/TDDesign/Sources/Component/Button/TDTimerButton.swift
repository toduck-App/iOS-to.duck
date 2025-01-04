import SnapKit
import UIKit

public final class TDTimerButton: TDBaseButton {
    private let outlineColor: UIColor
    private let icon: UIImage
    public init(_ state: TimerButtonState) {
        icon = state.icon
        outlineColor = state.outlineColor
        icon.withTintColor(state.foregroundColor, renderingMode: .alwaysOriginal)
        super.init(image: icon,backgroundColor: state.backgroundColor, foregroundColor: state.foregroundColor,radius: 40)
    }

    public func layout() {
        snp.makeConstraints {
            $0.width.height.equalTo(80)
        }
    }

    public override func setupButton() {
        layer.borderWidth = 5
        layer.borderColor = outlineColor.cgColor
        super.setupButton()
    }
}
