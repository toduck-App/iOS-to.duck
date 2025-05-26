import UIKit

final class TermOfUseViewController: BaseViewController<TermOfUseView> {
    weak var coordinator: TermOfUseCoordinator?

    override init() {
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configure() {
        navigationController?.setupNestedNavigationBar(
            leftButtonTitle: "이용 약관",
            leftButtonAction: UIAction(handler: { [weak self] _ in
                self?.coordinator?.finish(by: .pop)
            })
        )
    }
}
