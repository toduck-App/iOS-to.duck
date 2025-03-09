import Kingfisher
import SnapKit
import TDDesign
import Then
import UIKit

final class UserProfileView: UIView {
    private let avatarView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 30
        $0.clipsToBounds = true
        $0.backgroundColor = TDColor.Neutral.neutral100
    }
    
    private var horizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .center
        $0.distribution = .fill
    }
    
    private var verticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .leading
        $0.distribution = .fillProportionally
    }
    
    private var titleBagde = TDBadge(badgeTitle: "", backgroundColor: TDColor.Primary.primary25, foregroundColor: TDColor.Primary.primary500)
    
    private var nicknameLabel = TDLabel(labelText: "", toduckFont: .mediumHeader4, toduckColor: TDColor.Neutral.neutral800)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func configure(
        userAvatar: String,
        titleBadge: String,
        nickname: String,
        description: String? = nil
    ) {
        titleBagde.setTitle(titleBadge)
        nicknameLabel.setText(nickname)
        if let userAvatar = URL(string: userAvatar) {
            avatarView.kf.setImage(with: userAvatar)
        } else {
            avatarView.image = TDImage.Profile.medium
        }
        if let description {
            let descriptionLabel = TDLabel(labelText: description, toduckFont: .mediumCaption1, toduckColor: TDColor.Neutral.neutral600)
            verticalStackView.addArrangedSubview(descriptionLabel)
        }
    }
}

private extension UserProfileView {
    func setupUI() {
        setupLayout()
        setupConstraints()
    }
    
    func setupLayout() {
        addSubview(avatarView)
        addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(titleBagde)
        horizontalStackView.addArrangedSubview(nicknameLabel)
    }
    
    func setupConstraints() {
        avatarView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.size.equalTo(60)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalTo(avatarView.snp.trailing).offset(12)
            make.trailing.equalToSuperview()
        }
    }
}
