import UIKit
import TDCore
import TDDesign

final class PhoneVerificationView: BaseView {
    private let currentPageIcon = UIView().then {
        $0.backgroundColor = TDColor.Primary.primary500
        $0.layer.cornerRadius = 4
    }
    private let nextPageIcon = UIView().then {
        $0.backgroundColor = TDColor.Neutral.neutral200
        $0.layer.cornerRadius = 4
    }
    
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
    
    private let phoneLabel = TDLabel(
        labelText: "휴대폰 번호",
        toduckFont: .mediumHeader5,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    private(set) lazy var dropDownAnchorView = SocialListDropdownView(
        title: "통신사 선택"
    )
    lazy var carrierDropDownView = TDDropdownHoverView(
        anchorView: dropDownAnchorView,
        layout: .center,
        width: 128
    )
    let phoneNumberContainerView = UIView().then {
        $0.backgroundColor = TDColor.Neutral.neutral100
        $0.layer.cornerRadius = 8
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
    
    let nextButton = TDBaseButton(
        title: "계속하기",
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        font: TDFont.boldHeader5.font
    )
    
    override func addview() {
        phoneNumberContainerView.addSubview(phoneNumberTextField)
        [
            currentPageIcon,
            nextPageIcon,
            titleLabel,
            subTitleLabel,
            phoneLabel,
            carrierDropDownView,
            phoneNumberContainerView,
            postButton,
            nextButton
        ].forEach(addSubview)
    }
    
    override func layout() {
        currentPageIcon.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(12)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(16)
            make.height.equalTo(6)
        }
        nextPageIcon.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(12)
            make.leading.equalTo(currentPageIcon.snp.trailing).offset(8)
            make.size.equalTo(6)
        }
        
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(currentPageIcon.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(70)
            make.leading.equalTo(titleLabel)
        }
        
        dropDownAnchorView.snp.makeConstraints { make in
            make.top.equalTo(phoneLabel.snp.bottom).offset(24)
            make.leading.equalTo(titleLabel)
            make.width.equalTo(128)
            make.height.equalTo(40)
        }
        
        phoneNumberContainerView.snp.makeConstraints { make in
            make.top.equalTo(dropDownAnchorView.snp.bottom).offset(10)
            make.leading.equalTo(titleLabel)
            make.width.equalTo(260)
            make.height.equalTo(48)
        }
        phoneNumberTextField.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        postButton.snp.makeConstraints { make in
            make.top.equalTo(dropDownAnchorView.snp.bottom).offset(8)
            make.leading.equalTo(phoneNumberContainerView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(48)
        }
    }
    
    override func configure() {
        dropDownAnchorView.backgroundColor = TDColor.Neutral.neutral100
        dropDownAnchorView.layer.cornerRadius = 8
    }
}
