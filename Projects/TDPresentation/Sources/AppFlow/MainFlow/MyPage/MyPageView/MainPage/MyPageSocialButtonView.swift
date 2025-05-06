import SnapKit
import UIKit

protocol MyPageSocialButtonDelegate: AnyObject {
    func didTapProfileButton()
    func didTapShareButton()
}

final class MyPageSocialButtonView: UIView {
    weak var delegate: MyPageSocialButtonDelegate?

    private let menuStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = LayoutConstants.menuStackViewSpacing
        return stackView
    }()

    private var profileContainer = MyPageMenuContainer(type: .profile)
    private var shareContainer = MyPageMenuContainer(type: .share)

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupLayoutConstraints()
        attachGestures()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    private func setupViews() {
        addSubview(menuStackView)
        for item in [profileContainer, shareContainer] {
            menuStackView.addArrangedSubview(item)
            item.isUserInteractionEnabled = true
        }
    }

    private func setupLayoutConstraints() {
        menuStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(LayoutConstants.stackViewUpperPadding)
            $0.leading.trailing.equalToSuperview().inset(LayoutConstants.stackViewHorizontalPadding)
            $0.height.equalTo(54)
        }
    }

    private func attachGestures() {
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        profileContainer.addGestureRecognizer(profileTap)

        let shareTap = UITapGestureRecognizer(target: self, action: #selector(shareTapped))
        shareContainer.addGestureRecognizer(shareTap)
    }

    @objc private func profileTapped() {
        delegate?.didTapProfileButton()
    }

    @objc private func shareTapped() {
        delegate?.didTapShareButton()
    }
}

// MARK: - Constants

private extension MyPageSocialButtonView {
    enum LayoutConstants {
        static let menuStackViewSpacing: CGFloat = 10
        static let stackViewUpperPadding: CGFloat = 8
        static let stackViewLowerPadding: CGFloat = 20
        static let stackViewHorizontalPadding: CGFloat = 17.5
    }
}
