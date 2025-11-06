import UIKit
import TDCore
import TDDesign

protocol WithdrawViewDelegate: AnyObject {
    func withdrawViewDidTapNextButton(_ withdrawView: WithdrawView)
}

final class WithdrawView: BaseView {
    weak var delegate: WithdrawViewDelegate?
    
    private let labelStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = LayoutConstants.labelStackSpacing
        return stackView
    }()
    
    private let titleLabel = TDLabel(
        toduckFont: .boldHeader3,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    private let infoLabel = TDLabel(
        toduckFont: .mediumBody2,
        toduckColor: TDColor.Neutral.neutral500
    )
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = TDImage.Illust.withdraw
        return imageView
    }()
    
    private let checkboxStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = LayoutConstants.checkboxStackSpacing
        return stackView
    }()
    
    private let checkbox = TDCheckbox(
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite
    )
    
    private let checkboxLabel = TDLabel(
        toduckFont: .regularBody3,
        toduckColor: TDColor.Neutral.neutral600
    )
    
    private let nextButton = TDButton(
        title: "다음",
        size: .large
    )
    
    override func addview() {
        [titleLabel, infoLabel].forEach { labelStack.addArrangedSubview($0) }
        [checkbox, checkboxLabel].forEach { checkboxStack.addArrangedSubview($0) }
        [labelStack, imageView, checkboxStack, nextButton].forEach(addSubview)
    }
    
    override func configure() {
        titleLabel.setText("""
        \(TDTokenManager.shared.username)님,
        탈퇴하시겠어요?
        """)
        infoLabel.setText("""
        탈퇴 시 모든 일정과 루틴이 삭제되며, 
        이는 다시 복구될 수 없습니다.
        정말로 탈퇴하시겠어요?
        """)
        checkboxLabel.setText("회원 탈퇴 유의사항을 확인했어요")
        
        titleLabel.numberOfLines = 0
        infoLabel.numberOfLines = 0
        
        titleLabel.setLineHeightMultiple(LayoutConstants.labelLineHeightMultiple)
        infoLabel.setLineHeightMultiple(LayoutConstants.labelLineHeightMultiple)
        
        nextButton.isEnabled = false
        nextButton.layer.borderColor = TDColor.Primary.primary500.cgColor
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        checkbox.onToggle = { isChecked in
            self.nextButton.isEnabled = isChecked
        }
    }
    
    override func layout() {
        labelStack.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(LayoutConstants.topPadding)
            $0.leading.trailing.equalToSuperview().inset(LayoutConstants.horizontalPadding)
        }
        
        checkboxStack.snp.makeConstraints {
            $0.bottom.equalTo(nextButton.snp.top).offset(-LayoutConstants.checkboxPadding)
            $0.leading.equalToSuperview().offset(LayoutConstants.horizontalPadding)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(LayoutConstants.horizontalPadding)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(28)
            $0.height.equalTo(LayoutConstants.nextButtonSize)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(labelStack.snp.bottom)
            $0.bottom.equalTo(checkbox.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

private extension WithdrawView {
    @objc
    func nextButtonTapped() {
        delegate?.withdrawViewDidTapNextButton(self)
    }
}

private extension WithdrawView {
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
