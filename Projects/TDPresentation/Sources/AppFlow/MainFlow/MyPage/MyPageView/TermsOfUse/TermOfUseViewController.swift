import UIKit

final class TermOfUseViewController: BaseViewController<TermOfUseView> {
    var coordinator: TermOfUseCoordinator?

    override init() {
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
