import UIKit
import SnapKit
import TDCore
import TDDesign

final class SignInView: BaseView {
    // MARK: - UI Components
    
    /// 제목 및 설명
    private let titleLabel = TDLabel(
        labelText: "로그인",
        toduckFont: .boldHeader2,
        toduckColor: TDColor.Neutral.neutral800
    )
    private let subTitleLabel = TDLabel(
        labelText: "토덕을 이용하기 위한 로그인을 진행합니다.",
        toduckFont: .mediumHeader5,
        toduckColor: TDColor.Neutral.neutral600
    )
    
    /// 아이디 비밀번호 입력
    private let idLabel = TDLabel(
        labelText: "아이디 · 비밀번호",
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
    
    /// 아이디 · 비밀번호 찾기
    let findAccountContainerView = UIView()
    let findAccountLabel = TDLabel(
        labelText: "아이디 · 비밀번호 찾기",
        toduckFont: .regularBody3,
        toduckColor: TDColor.Neutral.neutral800
    )
    let arrowImageView = UIImageView().then {
        $0.image = TDImage.Direction.right2Medium
        $0.tintColor = TDColor.Neutral.neutral800
    }
    
    /// 로그인 버튼
    let nextButton = TDBaseButton(
        title: "로그인",
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        font: TDFont.boldHeader5.font
    )
    
    // MARK: - Initialize
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
        // 아이디 입력 필드 추가
        idContainerView.addSubview(idTextField)
        passwordContainerView.addSubview(passwordTextField)
        
        // 아이디 · 비밀번호 찾기 추가
        findAccountContainerView.addSubview(findAccountLabel)
        findAccountContainerView.addSubview(arrowImageView)
        
        // 전체 뷰 계층 추가
        [
            titleLabel,
            subTitleLabel,
            idLabel,
            idContainerView,
            passwordContainerView,
            findAccountContainerView,
            nextButton
        ].forEach(addSubview)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(LayoutConstants.titleTopOffset)
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
            make.leading.trailing.equalToSuperview().inset(LayoutConstants.horizontalInset)
            make.height.equalTo(LayoutConstants.inputFieldHeight)
        }
        
        idTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(LayoutConstants.inputPadding)
        }
        
        passwordContainerView.snp.makeConstraints { make in
            make.top.equalTo(idContainerView.snp.bottom).offset(LayoutConstants.inputSpacing)
            make.leading.trailing.equalToSuperview().inset(LayoutConstants.horizontalInset)
            make.height.equalTo(LayoutConstants.inputFieldHeight)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(LayoutConstants.inputPadding)
        }
        
        findAccountContainerView.snp.makeConstraints { make in
            make.top.equalTo(passwordContainerView.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview().inset(LayoutConstants.horizontalInset)
            make.height.equalTo(24)
        }
        
        findAccountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(findAccountLabel.snp.trailing)
            make.size.equalTo(LayoutConstants.iconSize)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(LayoutConstants.horizontalInset)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-LayoutConstants.buttonBottomSpacing)
            make.height.equalTo(LayoutConstants.buttonHeight)
        }
    }
    
    override func configure() {
        backgroundColor = TDColor.baseWhite
        nextButton.isEnabled = false
    }
}

// MARK: - Layout Constants
private enum LayoutConstants {
    static let titleTopOffset: CGFloat = 16
    static let subtitleSpacing: CGFloat = 12
    static let sectionSpacing: CGFloat = 40
    
    static let inputSpacing: CGFloat = 10
    static let inputPadding: CGFloat = 16
    static let inputFieldCornerRadius: CGFloat = 8
    static let inputFieldHeight: CGFloat = 56
    
    static let buttonHeight: CGFloat = 48
    static let buttonBottomSpacing: CGFloat = 16
    
    static let horizontalInset: CGFloat = 24
    static let iconSpacing: CGFloat = 4
    static let iconSize: CGFloat = 24
}
