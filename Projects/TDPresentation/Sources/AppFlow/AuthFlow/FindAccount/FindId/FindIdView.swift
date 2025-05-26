import UIKit
import SnapKit
import TDCore
import TDDesign

final class FindIdView: BaseView {
    // MARK: - UI Components
    
    /// 휴대폰 인증 입력 관련
    private let phoneLabel = TDLabel(
        labelText: "휴대폰 번호 인증",
        toduckFont: .mediumHeader5,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    /// 휴대폰 번호 입력 및 요청
    let phoneNumberContainerView = UIView().then {
        $0.layer.cornerRadius = LayoutConstants.inputFieldCornerRadius
        $0.backgroundColor = TDColor.Neutral.neutral50
        $0.layer.borderWidth = 1
        $0.layer.borderColor = TDColor.Neutral.neutral300.cgColor
    }
    let phoneNumberTextField = UITextField().then {
        $0.placeholder = "휴대폰 번호를 입력하세요"
        $0.font = TDFont.mediumHeader3.font
        $0.textColor = TDColor.Neutral.neutral800
        $0.keyboardType = .numberPad
        
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumFontSize = 10
    }
    let postButton = TDBaseButton(
        title: "인증요청",
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        font: TDFont.boldHeader5.font
    )
    let invaildPhoneNumberLabel = TDLabel(
        labelText: "올바르지 않은 휴대폰 번호 입니다.",
        toduckFont: .mediumBody3,
        toduckColor: TDColor.Semantic.error
    )
    
    /// 인증번호
    let verificationNumberContainerView = UIView().then {
        $0.layer.cornerRadius = LayoutConstants.inputFieldCornerRadius
        $0.backgroundColor = TDColor.Neutral.neutral50
        $0.layer.borderWidth = 1
        $0.layer.borderColor = TDColor.Neutral.neutral300.cgColor
    }
    let verificationNumberTextField = UITextField().then {
        $0.placeholder = "인증 번호를 입력하세요"
        $0.font = TDFont.mediumHeader3.font
        $0.textColor = TDColor.Neutral.neutral800
        $0.keyboardType = .numberPad
    }
    let verificationNumberTimerLabel = TDLabel(
        labelText: "5:00",
        toduckFont: .mediumHeader3,
        toduckColor: TDColor.Semantic.error
    )
    let invaildVerificationNumberLabel = TDLabel(
        labelText: "올바르지 않은 인증 번호 입니다.",
        toduckFont: .mediumBody3,
        toduckColor: TDColor.Semantic.error
    )
    
    let nextButton = TDBaseButton(
        title: "확인",
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        font: TDFont.boldHeader5.font
    )
    
    override func addview() {
        phoneNumberContainerView.addSubview(phoneNumberTextField)
        verificationNumberContainerView.addSubview(verificationNumberTextField)
        verificationNumberContainerView.addSubview(verificationNumberTimerLabel)
        
        [
            phoneLabel,
            phoneNumberContainerView,
            postButton,
            invaildPhoneNumberLabel,
            verificationNumberContainerView,
            invaildVerificationNumberLabel,
            nextButton
        ].forEach(addSubview)
    }
    
    override func layout() {
        phoneLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(LayoutConstants.titleTopOffset)
            make.leading.equalToSuperview().offset(LayoutConstants.horizontalInset)
        }
        
        phoneNumberContainerView.snp.makeConstraints { make in
            make.top.equalTo(phoneLabel.snp.bottom).offset(LayoutConstants.inputSpacing)
            make.leading.equalTo(phoneLabel)
            make.trailing.equalTo(postButton.snp.leading).offset(-10)
            make.height.equalTo(LayoutConstants.inputFieldHeight)
        }
        phoneNumberTextField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(LayoutConstants.inputPadding)
        }
        postButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-LayoutConstants.horizontalInset)
            make.width.equalTo(LayoutConstants.buttonWidth)
            make.height.equalTo(LayoutConstants.buttonHeight)
            make.centerY.equalTo(phoneNumberContainerView)
        }
        invaildPhoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberContainerView.snp.bottom).offset(LayoutConstants.inputSpacing)
            make.leading.equalTo(phoneNumberContainerView).offset(LayoutConstants.inputPadding)
        }
        
        verificationNumberContainerView.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberContainerView.snp.bottom).offset(LayoutConstants.inputSpacing)
            make.leading.equalTo(phoneLabel)
            make.trailing.equalToSuperview().offset(-LayoutConstants.horizontalInset)
            make.height.equalTo(LayoutConstants.inputFieldHeight)
        }
        verificationNumberTextField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(LayoutConstants.inputPadding)
            make.trailing.equalTo(verificationNumberTimerLabel.snp.leading).offset(-LayoutConstants.inputPadding)
        }
        
        verificationNumberTimerLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-LayoutConstants.inputPadding)
        }
        invaildVerificationNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(verificationNumberContainerView.snp.bottom).offset(LayoutConstants.inputSpacing)
            make.leading.equalTo(phoneLabel).offset(LayoutConstants.inputPadding)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(LayoutConstants.horizontalInset)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-LayoutConstants.buttonBottomSpacing)
            make.height.equalTo(LayoutConstants.buttonHeight)
        }
    }
    
    override func configure() {
        backgroundColor = TDColor.baseWhite
        verificationNumberContainerView.isHidden = true
        invaildPhoneNumberLabel.isHidden = true
        invaildVerificationNumberLabel.isHidden = true
        nextButton.isEnabled = false
    }
}

// MARK: - Layout Constants
private enum LayoutConstants {
    static let pageIndicatorTopOffset: CGFloat = 12
    static let pageIndicatorWidth: CGFloat = 16
    static let pageIndicatorHeight: CGFloat = 6
    static let nextPageIconSize: CGFloat = 6
    static let pageIndicatorCornerRadius: CGFloat = 4
    
    static let titleTopOffset: CGFloat = 44
    static let subtitleSpacing: CGFloat = 4
    static let sectionSpacing: CGFloat = 70
    
    static let inputSpacing: CGFloat = 10
    static let inputPadding: CGFloat = 16
    static let inputFieldCornerRadius: CGFloat = 8
    static let inputFieldHeight: CGFloat = 56
    static let carrierContainerWidth: CGFloat = 152
    static let phoneInputWidth: CGFloat = 260
    
    static let buttonSpacing: CGFloat = 8
    static let buttonWidth: CGFloat = 108
    static let buttonHeight: CGFloat = 48
    static let buttonBottomSpacing: CGFloat = 16
    
    static let horizontalInset: CGFloat = 24
    static let iconSpacing: CGFloat = 8
    static let iconSize: CGFloat = 24
}
