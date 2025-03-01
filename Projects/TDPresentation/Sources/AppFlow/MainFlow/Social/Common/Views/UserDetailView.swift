import SnapKit
import TDDesign
import Then
import UIKit

final class UserDetailView: UIView {
    private let followingLabel = TDLabel(labelText: "팔로잉", toduckFont: .mediumCaption1, toduckColor: TDColor.Neutral.neutral600)

    private let followingCountLabel = TDLabel(labelText: "0", toduckFont: .boldBody2, toduckColor: TDColor.Neutral.neutral800)

    private let followerLabel = TDLabel(labelText: "팔로워", toduckFont: .mediumCaption1, toduckColor: TDColor.Neutral.neutral600)

    private let followerCountLabel = TDLabel(labelText: "0", toduckFont: .boldBody2, toduckColor: TDColor.Neutral.neutral800)

    private let postLabel = TDLabel(labelText: "작성한 글", toduckFont: .mediumCaption1, toduckColor: TDColor.Neutral.neutral600)

    private let postCountLabel = TDLabel(labelText: "0", toduckFont: .boldBody2, toduckColor: TDColor.Neutral.neutral800)

    private let firstSeparatorView = UIView().then {
        $0.backgroundColor = TDColor.Neutral.neutral100
    }

    private let secondSeparatorView = UIView().then {
        $0.backgroundColor = TDColor.Neutral.neutral100
    }

    private lazy var followingStack = UIStackView(arrangedSubviews: [followingLabel, followingCountLabel]).then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 4
    }

    private lazy var followerStack = UIStackView(arrangedSubviews: [followerLabel, followerCountLabel]).then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 4
    }

    private lazy var postStack = UIStackView(arrangedSubviews: [postLabel, postCountLabel]).then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 4
    }

    private lazy var horizontalStack = UIStackView(arrangedSubviews: [
        followingStack,
        firstSeparatorView,
        followerStack,
        secondSeparatorView,
        postStack
    ]).then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.spacing = 16
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func configure(
        followingCount: Int,
        followerCount: Int,
        postCount: Int
    ) {
        followingCountLabel.setText("\(followingCount)")
        followerCountLabel.setText("\(followerCount)")
        postCountLabel.setText("\(postCount)")
    }
}

private extension UserDetailView {
    func setupUI() {
        setupLayout()
        setupConstraints()
    }

    func setupLayout() {
        addSubview(horizontalStack)
    }

    func setupConstraints() {
        horizontalStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }

        for item in [followingStack, followerStack, postStack] {
            item.snp.makeConstraints { make in
                make.width.equalTo(80)
            }
        }

        firstSeparatorView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(32)
        }

        secondSeparatorView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(32)
        }
    }
}
