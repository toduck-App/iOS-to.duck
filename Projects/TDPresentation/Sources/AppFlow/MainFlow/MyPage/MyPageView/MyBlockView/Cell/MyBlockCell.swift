import UIKit
import SnapKit
import TDDesign

final class MyBlockCell: UICollectionViewCell {
    var avatarView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
        $0.backgroundColor = TDColor.Neutral.neutral100
    }
    
    var nicknameLabel = TDLabel(toduckFont: .boldBody3, toduckColor: TDColor.Neutral.neutral800).then {
        $0.numberOfLines = 1
    }
    
    var blockButton = TDBaseButton(
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        font: TDFont.boldBody2.font
    ).then {
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = TDColor.Neutral.neutral300.cgColor
        $0.setTitle("차단", for: .selected)
        $0.setTitle("해제", for: .normal)
        $0.isSelected = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(avatarView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(blockButton)
        
        avatarView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarView.snp.trailing).offset(10)
            make.centerY.equalTo(avatarView)
        }
        
        blockButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(avatarView)
            make.height.equalTo(32)
            make.width.equalTo(60)
        }
    }
    
    func configure(
        avatarURL: String?,
        nickname: String,
        isBlocked: Bool
    ) {
        if let avatarURL = avatarURL {
            avatarView.kf.setImage(with: URL(string: avatarURL))
        } else {
            avatarView.image = TDImage.Profile.medium
        }
        nicknameLabel.setText(nickname)
    }
}
