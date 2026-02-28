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
        $0.contentMode = .scaleAspectFill
        $0.image = TDImage.Illust.shareProfile
    }
    
    let inviteButton = TDButton(
        title: "초대장 보내기",
        size: .large
    )
    
    private let topBlurGradientView = TopBlurGradientCircleView(color: TDColor.Primary.primary500)
    
    override func addview() {
        [titleLabel, infoLabel].forEach { labelStack.addArrangedSubview($0) }
        [labelStack, imageView, inviteButton, topBlurGradientView].forEach(addSubview)
    }
    
    override func configure() {
        backgroundColor = TDColor.baseWhite
        titleLabel.setText("""
        혼자보다 함께, 실행이 더 쉬워져요!
        나와 함께할 친구에게 초대장을 보내보세요 ✉️
        """)
        infoLabel.setText("""
        함께하는 친구는 또 다른 동기부여가 돼요.
        당신의 루틴에 힘을 더해 보세요!
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
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
        topBlurGradientView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(1.2)
            $0.height.equalTo(topBlurGradientView.snp.width)
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
