import UIKit
import TDCore
import TDDesign

final class AccountView: BaseView {
    // MARK: - UI Components
    
    /// 페이지 진행 표시 아이콘
    private let prePageIcon = UIView().then {
        $0.backgroundColor = TDColor.Neutral.neutral200
        $0.layer.cornerRadius = LayoutConstants.pageIndicatorCornerRadius
    }
    
    private let currentPageIcon = UIView().then {
        $0.backgroundColor = TDColor.Primary.primary500
        $0.layer.cornerRadius = LayoutConstants.pageIndicatorCornerRadius
    }
    
    /// 제목 및 설명
    private let titleLabel = TDLabel(
        labelText: "회원가입",
        toduckFont: .boldHeader2,
        toduckColor: TDColor.Neutral.neutral800
    )
    
    private let subTitleLabel = TDLabel(
        labelText: "마지막 단계에요!",
        toduckFont: .mediumHeader5,
        toduckColor: TDColor.Neutral.neutral600
    )
    
    /// 아이디 입력
    private let idLabel = TDLabel(
        labelText: "아이디",
        toduckFont: .mediumHeader5,
        toduckColor: TDColor.Neutral.neutral800
    )
    let idContainerView = UIView().then {
        $0.backgroundColor = TDColor.Neutral.neutral100
        $0.layer.cornerRadius = LayoutConstants.inputFieldCornerRadius
    }
    let idTextField = UITextField().then {
        $0.placeholder = "아이디를 입력하세요"
        $0.font = TDFont.mediumHeader3.font
        $0.textColor = TDColor.Neutral.neutral800
    }
    let duplicateVerificationButton = TDBaseButton(
        title: "중복확인",
        backgroundColor: TDColor.baseWhite,
        foregroundColor: TDColor.Neutral.neutral600,
        font: TDFont.boldHeader5.font
    ).then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = TDColor.Neutral.neutral300.cgColor
    }
    let idFieldStateLabel = TDLabel(
        labelText: "",
        toduckFont: .mediumBody3,
        toduckColor: TDColor.Semantic.error
    )
    
    /// 비밀번호 입력
    private let passwordLabel = TDLabel(
        labelText: "비밀번호",
        toduckFont: .mediumHeader5,
        toduckColor: TDColor.Neutral.neutral800
    )
    private let passwordStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    let passwordContainerView = UIView().then {
        $0.backgroundColor = TDColor.Neutral.neutral100
        $0.layer.cornerRadius = LayoutConstants.inputFieldCornerRadius
    }
    let passwordTextField = UITextField().then {
        $0.placeholder = "비밀번호를 입력하세요"
        $0.font = TDFont.mediumHeader3.font
        $0.textColor = TDColor.Neutral.neutral800
        $0.isSecureTextEntry = true
    }
    // TODO: 오토레이아웃 조정해서 애니메이션으로 Invalid 표시
    private let invaildPasswordHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.spacing = 16
    }
    let invaildPasswordDummyView = UIView()
    let invaildPasswordLabel = TDLabel(
        labelText: "8~16자 영문 대/소문자, 숫자, 특수문자를 사용해 주세요.",
        toduckFont: .mediumBody3,
        toduckColor: TDColor.Semantic.error
    )
    
    private let verifypasswordStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    let verifyPasswordContainerView = UIView().then {
        $0.backgroundColor = TDColor.Neutral.neutral100
        $0.layer.cornerRadius = LayoutConstants.inputFieldCornerRadius
    }
    let verifyPasswordTextField = UITextField().then {
        $0.placeholder = "비밀번호 확인"
        $0.font = TDFont.mediumHeader3.font
        $0.textColor = TDColor.Neutral.neutral800
        $0.isSecureTextEntry = true
    }
    private let invaildVerifyPasswordHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.spacing = 16
    }
    let invaildVerifyPasswordDummyView = UIView()
    let invaildVerifyPasswordLabel = TDLabel(
        labelText: "비밀번호가 일치하지 않습니다.",
        toduckFont: .mediumBody3,
        toduckColor: TDColor.Semantic.error
    )
    
    let nextButton = TDBaseButton(
        title: "계속하기",
        backgroundColor: TDColor.Neutral.neutral300,
        foregroundColor: TDColor.Neutral.neutral500,
        font: TDFont.boldHeader5.font
    )
    
    override func addview() {
        idContainerView.addSubview(idTextField)
        setupPasswordInputView()
        setupVerifyPasswordInputView()
        setupMainView()
    }
    
    private func setupPasswordInputView() {
        passwordContainerView.addSubview(passwordTextField)
        
        invaildPasswordHorizontalStackView.addArrangedSubview(invaildPasswordDummyView)
        invaildPasswordHorizontalStackView.addArrangedSubview(invaildPasswordLabel)
        
        passwordStackView.addArrangedSubview(passwordContainerView)
        passwordStackView.addArrangedSubview(invaildPasswordHorizontalStackView)
    }
    
    private func setupVerifyPasswordInputView() {
        verifyPasswordContainerView.addSubview(verifyPasswordTextField)
        
        invaildVerifyPasswordHorizontalStackView.addArrangedSubview(invaildVerifyPasswordDummyView)
        invaildVerifyPasswordHorizontalStackView.addArrangedSubview(invaildVerifyPasswordLabel)
        
        verifypasswordStackView.addArrangedSubview(verifyPasswordContainerView)
        verifypasswordStackView.addArrangedSubview(invaildVerifyPasswordHorizontalStackView)
    }
    
    private func setupMainView() {
        [
            prePageIcon,
            currentPageIcon,
            titleLabel,
            subTitleLabel,
            idLabel,
            idContainerView,
            idFieldStateLabel,
            duplicateVerificationButton,
            passwordLabel,
            passwordStackView,
            verifypasswordStackView,
            nextButton
        ].forEach(addSubview)
    }
    
    override func layout() {
        prePageIcon.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(LayoutConstants.pageIndicatorTopOffset)
            make.leading.equalToSuperview().offset(LayoutConstants.horizontalInset)
            make.size.equalTo(LayoutConstants.nextPageIconSize)
        }
        currentPageIcon.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(LayoutConstants.pageIndicatorTopOffset)
            make.leading.equalTo(prePageIcon.snp.trailing).offset(LayoutConstants.iconSpacing)
            make.width.equalTo(LayoutConstants.pageIndicatorWidth)
            make.height.equalTo(LayoutConstants.pageIndicatorHeight)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(currentPageIcon.snp.bottom).offset(LayoutConstants.titleTopOffset)
            make.leading.equalToSuperview().offset(LayoutConstants.horizontalInset)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(LayoutConstants.subtitleSpacing)
            make.leading.equalTo(titleLabel)
        }
        
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(LayoutConstants.sectionSpacing)
            make.leading.equalTo(titleLabel)
        }
        idContainerView.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(LayoutConstants.inputSpacing)
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(duplicateVerificationButton.snp.leading).offset(-LayoutConstants.inputSpacing)
            make.height.equalTo(LayoutConstants.inputFieldHeight)
        }
        idTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(LayoutConstants.inputPadding)
        }
        duplicateVerificationButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-LayoutConstants.horizontalInset)
            make.centerY.equalTo(idContainerView)
            make.height.equalTo(LayoutConstants.buttonHeight)
            make.width.equalTo(LayoutConstants.duplicateButtonWidth)
        }
        idFieldStateLabel.snp.makeConstraints { make in
            make.top.equalTo(idContainerView.snp.bottom).offset(LayoutConstants.inputSpacing)
            make.leading.equalTo(titleLabel).offset(LayoutConstants.inputPadding)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(idFieldStateLabel.snp.bottom).offset(44)
            make.leading.equalTo(titleLabel)
        }
        passwordStackView.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(LayoutConstants.inputSpacing)
            make.leading.trailing.equalToSuperview().inset(LayoutConstants.horizontalInset)
        }
        passwordContainerView.snp.makeConstraints { make in
            make.height.equalTo(LayoutConstants.inputFieldHeight)
        }
        passwordTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(LayoutConstants.inputPadding)
        }
        invaildPasswordDummyView.snp.makeConstraints { make in
            make.width.equalTo(0)
        }
        
        verifypasswordStackView.snp.makeConstraints { make in
            make.top.equalTo(passwordStackView.snp.bottom).offset(LayoutConstants.inputSpacing)
            make.leading.trailing.equalToSuperview().inset(LayoutConstants.horizontalInset)
        }
        verifyPasswordContainerView.snp.makeConstraints { make in
            make.height.equalTo(LayoutConstants.inputFieldHeight)
        }
        verifyPasswordTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(LayoutConstants.inputPadding)
        }
        invaildVerifyPasswordDummyView.snp.makeConstraints { make in
            make.width.equalTo(0)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(LayoutConstants.horizontalInset)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-LayoutConstants.buttonBottomSpacing)
            make.height.equalTo(LayoutConstants.buttonHeight)
        }
    }
    
    override func configure() {
        invaildPasswordLabel.isHidden = true
        invaildVerifyPasswordLabel.isHidden = true
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
    static let sectionSpacing: CGFloat = 40
    
    static let inputSpacing: CGFloat = 10
    static let inputPadding: CGFloat = 16
    static let inputFieldCornerRadius: CGFloat = 8
    static let inputFieldHeight: CGFloat = 56
    static let duplicateButtonWidth: CGFloat = 100
    
    static let buttonHeight: CGFloat = 48
    static let buttonBottomSpacing: CGFloat = 16
    
    static let horizontalInset: CGFloat = 16
    static let iconSpacing: CGFloat = 8
}
