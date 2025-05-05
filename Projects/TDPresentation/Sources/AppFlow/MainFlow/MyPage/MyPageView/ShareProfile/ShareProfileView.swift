import SnapKit
import TDDesign
import UIKit

final class ShareProfileView: BaseView {
    private let labelStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 14
        return stackView
    }()
    
    let titleLabel = TDLabel(
        toduckFont: .boldHeader3,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    private let infoLabel = TDLabel(
        toduckFont: .mediumBody2,
        toduckColor: TDColor.Neutral.neutral500
    )
    
    private let imageView = UIImageView().then {
        $0.contentMode = .center
        $0.image = TDImage.Illust.shareProfile
    }
    
    let inviteButton = TDButton(
        title: "초대장 보내기",
        size: .large
    )
    
    override func addview() {
        [titleLabel, infoLabel].forEach { labelStack.addArrangedSubview($0) }
        [labelStack, imageView, inviteButton].forEach(addSubview)
    }
    
    override func configure() {
        backgroundColor = TDColor.baseWhite
        titleLabel.setText("""
        나와 함께할 친구에게
        초대장을 보내보세요!
        """)
        infoLabel.setText("""
        친구와 함께 하면 더 큰 시너지를 낼 수 있어요!
        """)
        titleLabel.numberOfLines = 0
        infoLabel.numberOfLines = 0
        
        titleLabel.setLineHeightMultiple(1.2)
        infoLabel.setLineHeightMultiple(1.2)
        
        inviteButton.layer.borderColor = TDColor.Primary.primary500.cgColor
    }
    
    override func layout() {
        labelStack.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(LayoutConstants.topPadding)
            $0.leading.trailing.equalToSuperview().inset(LayoutConstants.horizontalPadding)
        }
        
        inviteButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(LayoutConstants.horizontalPadding)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(16)
            $0.height.equalTo(LayoutConstants.nextButtonSize)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(labelStack.snp.bottom)
            $0.bottom.equalTo(inviteButton.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

extension ShareProfileView {
    enum LayoutConstants {
        static let topPadding: CGFloat = 18
        static let labelLineHeightMultiple: CGFloat = 1.2
        static let labelStackSpacing: CGFloat = 14
        static let horizontalPadding: CGFloat = 16
        static let imageViewPadding: CGFloat = 38
        static let checkboxStackSpacing: CGFloat = 8
        static let checkboxPadding: CGFloat = 56
        static let nextButtonSize: CGFloat = 56
        static let bottomPadding: CGFloat = 28
    }
}
