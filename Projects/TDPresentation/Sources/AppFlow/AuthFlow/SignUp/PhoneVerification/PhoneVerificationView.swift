import UIKit
import TDCore
import TDDesign

final class PhoneVerificationView: BaseView {
    
    // MARK: - UI Components
    
    /// 페이지 진행 표시 아이콘
    private let currentPageIcon = UIView().then {
        $0.backgroundColor = TDColor.Primary.primary500
        $0.layer.cornerRadius = LayoutConstants.pageIndicatorCornerRadius
    }
    
    private let nextPageIcon = UIView().then {
        $0.backgroundColor = TDColor.Neutral.neutral200
        $0.layer.cornerRadius = LayoutConstants.pageIndicatorCornerRadius
    }
    
    /// 제목 및 설명
    private let titleLabel = TDLabel(
        labelText: "휴대폰 본인인증",
        toduckFont: .boldHeader2,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    private let subTitleLabel = TDLabel(
        labelText: "회원여부 확인 및 가입을 진행합니다.",
        toduckFont: .mediumHeader5,
        toduckColor: TDColor.Neutral.neutral600
    )
    
    /// 휴대폰 인증 입력 관련
    private let phoneLabel = TDLabel(
        labelText: "휴대폰 번호",
        toduckFont: .mediumHeader5,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    private let carrierContainerView = UIView()
    
    let carrierLabel = TDLabel(
        labelText: "통신사 선택",
        toduckFont: .mediumHeader3,
        toduckColor: TDColor.Neutral.neutral600
    )
    
    private let downImage = UIImageView().then {
        $0.tintColor = TDColor.Neutral.neutral500
        $0.contentMode = .scaleAspectFit
        $0.image = TDImage.downMedium.withRenderingMode(.alwaysTemplate)
    }
    
    lazy var carrierDropDownView = TDDropdownHoverView(
        anchorView: carrierContainerView,
        layout: .center,
        width: LayoutConstants.carrierContainerWidth
    )
    
    /// 휴대폰 번호 입력 및 요청
    let phoneNumberContainerView = UIView().then {
        $0.backgroundColor = TDColor.Neutral.neutral100
        $0.layer.cornerRadius = LayoutConstants.inputFieldCornerRadius
    }
    let phoneNumberTextField = UITextField().then {
        $0.placeholder = "휴대폰 번호를 입력하세요"
        $0.font = TDFont.mediumHeader3.font
        $0.textColor = TDColor.Neutral.neutral800
        $0.keyboardType = .numberPad
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
        $0.backgroundColor = TDColor.Neutral.neutral100
        $0.layer.cornerRadius = LayoutConstants.inputFieldCornerRadius
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
        title: "계속하기",
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        font: TDFont.boldHeader5.font
    )
    
    override func addview() {
        carrierContainerView.addSubview(carrierLabel)
        carrierContainerView.addSubview(downImage)
        phoneNumberContainerView.addSubview(phoneNumberTextField)
        verificationNumberContainerView.addSubview(verificationNumberTextField)
        verificationNumberContainerView.addSubview(verificationNumberTimerLabel)
        
        [
            currentPageIcon,
            nextPageIcon,
            titleLabel,
            subTitleLabel,
            phoneLabel,
            carrierDropDownView,
            phoneNumberContainerView,
            postButton,
            invaildPhoneNumberLabel,
            verificationNumberContainerView,
            invaildVerificationNumberLabel,
            nextButton
        ].forEach(addSubview)
        
        carrierContainerView.backgroundColor = TDColor.Neutral.neutral100
        carrierContainerView.layer.cornerRadius = LayoutConstants.inputFieldCornerRadius
    }
    
    override func layout() {
        currentPageIcon.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(LayoutConstants.pageIndicatorTopOffset)
            make.leading.equalToSuperview().offset(LayoutConstants.horizontalInset)
            make.width.equalTo(LayoutConstants.pageIndicatorWidth)
            make.height.equalTo(LayoutConstants.pageIndicatorHeight)
        }
        
        nextPageIcon.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(LayoutConstants.pageIndicatorTopOffset)
            make.leading.equalTo(currentPageIcon.snp.trailing).offset(LayoutConstants.iconSpacing)
            make.size.equalTo(LayoutConstants.nextPageIconSize)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(currentPageIcon.snp.bottom).offset(LayoutConstants.titleTopOffset)
            make.leading.equalToSuperview().offset(LayoutConstants.horizontalInset)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(LayoutConstants.subtitleSpacing)
            make.leading.equalTo(titleLabel)
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(LayoutConstants.sectionSpacing)
            make.leading.equalTo(titleLabel)
        }
        
        carrierContainerView.snp.makeConstraints { make in
            make.top.equalTo(phoneLabel.snp.bottom).offset(LayoutConstants.inputSpacing)
            make.leading.equalTo(titleLabel)
            make.width.equalTo(LayoutConstants.carrierContainerWidth)
            make.height.equalTo(LayoutConstants.inputFieldHeight)
        }
        
        carrierLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview().offset(-LayoutConstants.iconSpacing)
        }
        
        downImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(carrierLabel.snp.trailing).offset(LayoutConstants.iconSpacing)
            make.size.equalTo(LayoutConstants.iconSize)
        }
        
        phoneNumberContainerView.snp.makeConstraints { make in
            make.top.equalTo(carrierContainerView.snp.bottom).offset(LayoutConstants.inputSpacing)
            make.leading.equalTo(titleLabel)
            make.width.equalTo(LayoutConstants.phoneInputWidth)
            make.height.equalTo(LayoutConstants.inputFieldHeight)
        }
        phoneNumberTextField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(LayoutConstants.inputPadding)
        }
        postButton.snp.makeConstraints { make in
            make.leading.equalTo(phoneNumberContainerView.snp.trailing).offset(LayoutConstants.inputSpacing)
            make.trailing.equalToSuperview().offset(-LayoutConstants.horizontalInset)
            make.height.equalTo(LayoutConstants.buttonHeight)
            make.centerY.equalTo(phoneNumberContainerView)
        }
        invaildPhoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberContainerView.snp.bottom).offset(LayoutConstants.inputSpacing)
            make.leading.equalTo(phoneNumberContainerView).offset(LayoutConstants.inputPadding)
        }
        
        verificationNumberContainerView.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberContainerView.snp.bottom).offset(LayoutConstants.inputSpacing)
            make.leading.equalTo(titleLabel)
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
            make.leading.equalTo(titleLabel).offset(LayoutConstants.inputPadding)
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
    
    static let titleTopOffset: CGFloat = 16
    static let subtitleSpacing: CGFloat = 4
    static let sectionSpacing: CGFloat = 70
    
    static let inputSpacing: CGFloat = 10
    static let inputPadding: CGFloat = 16
    static let inputFieldCornerRadius: CGFloat = 8
    static let inputFieldHeight: CGFloat = 56
    static let carrierContainerWidth: CGFloat = 152
    static let phoneInputWidth: CGFloat = 260
    
    static let buttonSpacing: CGFloat = 8
    static let buttonHeight: CGFloat = 48
    static let buttonBottomSpacing: CGFloat = 16
    
    static let horizontalInset: CGFloat = 16
    static let iconSpacing: CGFloat = 8
    static let iconSize: CGFloat = 24
}
