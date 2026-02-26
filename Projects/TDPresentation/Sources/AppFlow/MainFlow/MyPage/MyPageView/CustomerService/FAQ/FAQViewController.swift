import UIKit
import TDDesign

final class FAQViewController: BaseViewController<FAQView> {
    weak var coordinator: FAQCoordinator?

    override init() {
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configure() {
        navigationController?.setupNestedNavigationBar(
            leftButtonTitle: "",
            leftButtonAction: UIAction(handler: { [weak self] _ in
                self?.coordinator?.finish(by: .pop)
            })
        )
    }
}
