import UIKit

final class MyBlockViewController: BaseViewController<MyBlockView> {
    weak var coordinator: MyBlockCoordinator?
        
    override func configure() {
        layoutView.backgroundColor = .white
        navigationController?.setupNestedNavigationBar(
            leftButtonTitle: "차단 관리",
            leftButtonAction: UIAction { [weak self] _ in
                self?.coordinator?.finish(by: .pop)
            }
        )
    }
}
