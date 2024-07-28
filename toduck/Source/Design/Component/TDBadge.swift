import Foundation
import UIKit

public final class TDBadge: UIView {
    private var title: String!
    private var backgroundToduckColor: UIColor!
    private var foregroundToduckColor: UIColor!

    private var label: TDLabel!
    convenience init(_ title: String, backgroundToduckColor: UIColor = TDColor.Primary.primary25, foregroundToduckColor: UIColor = TDColor.Primary.primary500) {
        self.init(frame: .zero)
        self.title = title
        self.backgroundToduckColor = backgroundToduckColor
        self.foregroundToduckColor = foregroundToduckColor
        setupBadge()
        layout()
    }

    func setupBadge() {
        label = TDLabel(toduckFont: .mediumCaption2, toduckColor: foregroundToduckColor, labelText: title)
        label.textAlignment = .center
        label.sizeToFit()
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        label.backgroundColor = backgroundToduckColor
        addSubview(label)


    }

    func layout() {
        label.snp.makeConstraints {
            $0.width.equalTo(54)
            $0.height.equalTo(20)
            $0.bottom.top.equalToSuperview()
            $0.leading.leading.equalToSuperview().inset(10)
        }
    }
}