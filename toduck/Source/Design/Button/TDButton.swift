import Foundation
import SnapKit
import UIKit

public final class TDButton: TDBaseButton {
    var size: ButtonSize!

    init(frame _: CGRect = .zero, title: String, size: ButtonSize = .medium) {
        self.size = size

        // MARK: - 함수가 두번 호출됨
        super.init(title: title)
        setRadius(radius: CGFloat(size == .medium ? 12 : 8))
        setFont(toduckFont: size == .medium ? TDFont.boldHeader3 : TDFont.boldBody2)
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func makeConstraints() {
        let height: CGFloat = size == .medium ? 54 : 32

        snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
}
