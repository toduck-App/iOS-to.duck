import UIKit
import SnapKit

import TDDesign

enum ContainerType {
    case profile
    case share
}

final class MyPageMenuContainer: UIView {
    let icon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = LayoutConstants.iconCornerRadius
    }
    
    let label = TDLabel(toduckFont: .mediumBody2, toduckColor: TDColor.Neutral.neutral800)
    
    init(type: ContainerType) {
        super.init(frame: .zero)
        setupViews(type: type)
        setupLayoutConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension MyPageMenuContainer {
    func setupViews(type: ContainerType) {
        layer.cornerRadius = LayoutConstants.containerCornerRadius
        backgroundColor = TDColor.Neutral.neutral50
        [icon, label].forEach { addSubview($0) }
        
        switch type {
        case .profile:
            icon.image = TDImage.Pen.penNeutralColor.withRenderingMode(.alwaysOriginal)
            icon.tintColor = TDColor.Neutral.neutral800
            label.setText("프로필")
        case .share:
            icon.image = TDImage.Social.medium
            label.setText("공유하기")
        }
    }
    
    func setupLayoutConstraints() {
        icon.snp.makeConstraints {
            $0.top.equalToSuperview().offset(LayoutConstants.verticalPadding)
            $0.size.equalTo(LayoutConstants.iconSize)
            $0.centerX.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-LayoutConstants.verticalPadding)
            $0.centerX.equalToSuperview()
        }
    }
}

// MARK: - Constants
private extension MyPageMenuContainer {
    enum LayoutConstants {
        static let iconSize: CGFloat = 24
        static let verticalPadding: CGFloat = 14
        static let iconCornerRadius: CGFloat = 4
        static let containerCornerRadius: CGFloat = 8
    }
}
