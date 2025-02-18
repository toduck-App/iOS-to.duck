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
    
    /// 버튼들
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
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
        setupConstraints()
    }
    
    // MARK: - Setup UI
    private func configureUI() {
        carrierContainerView.addSubview(carrierLabel)
        carrierContainerView.addSubview(downImage)
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
        
        carrierContainerView.backgroundColor = TDColor.Neutral.neutral100
        carrierContainerView.layer.cornerRadius = LayoutConstants.inputFieldCornerRadius
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
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
            make.top.equalTo(carrierContainerView.snp.bottom).offset(LayoutConstants.buttonSpacing)
            make.leading.equalTo(phoneNumberContainerView.snp.trailing).offset(LayoutConstants.inputSpacing)
            make.trailing.equalToSuperview().offset(-LayoutConstants.horizontalInset)
            make.height.equalTo(LayoutConstants.buttonHeight)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(LayoutConstants.horizontalInset)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-LayoutConstants.buttonBottomSpacing)
            make.height.equalTo(LayoutConstants.buttonHeight)
        }
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
    static let inputFieldHeight: CGFloat = 48
    static let carrierContainerWidth: CGFloat = 152
    static let phoneInputWidth: CGFloat = 260
    
    static let buttonSpacing: CGFloat = 8
    static let buttonHeight: CGFloat = 48
    static let buttonBottomSpacing: CGFloat = 16
    
    static let horizontalInset: CGFloat = 16
    static let iconSpacing: CGFloat = 8
    static let iconSize: CGFloat = 24
}
