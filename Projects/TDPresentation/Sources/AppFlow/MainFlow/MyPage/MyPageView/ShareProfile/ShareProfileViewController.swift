import SnapKit
import TDCore
import TDDesign
import UIKit

final class ShareProfileViewController: BaseViewController<ShareProfileView> {
    weak var coordinator: ShareProfileCoordinator?

    override init() {
        super.init()
    }

    override func configure() {
        navigationController?.setupNestedNavigationBar(
            leftButtonTitle: "공유하기",
            leftButtonAction: UIAction(handler: { [weak self] _ in
                self?.coordinator?.finish(by: .pop)
            })
        )

        layoutView.inviteButton.addAction(UIAction {
            [weak self] _ in
            self?.didTapShareButton()
        }, for: .touchUpInside)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func didTapShareButton() {
        guard let userId = TDTokenManager.shared.userId else { return }
        let icon = TDImage.appIcon
        let profileURL = URL(string: "https://toduck.app/_ul/profile?userId=\(userId)")!
        let shareItem = ProfileShareItem(
            url: profileURL,
            title: "Toduck에서 나의 프로필을 확인하세요!",
            icon: icon
        )

        let activityVC = UIActivityViewController(
            activityItems: [shareItem],
            applicationActivities: nil
        )

        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = layoutView.inviteButton
        }
        present(activityVC, animated: true)
    }
}
