import UIKit
import TDDesign

final class ShowPasswordViewController: BaseViewController<BaseView> {
    // MARK: UI Components
    private let passwordLabel = TDLabel(
        labelText: "새 비밀번호 입력",
        toduckFont: .mediumHeader5,
        toduckColor: TDColor.Neutral.neutral800
    )
    private let passwordStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    let passwordContainerView = UIView().then {
        $0.backgroundColor = TDColor.Neutral.neutral50
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = TDColor.Neutral.neutral300.cgColor
    }
    let passwordTextField = UITextField().then {
        $0.placeholder = "새 비밀번호"
        $0.font = TDFont.mediumHeader3.font
        $0.textColor = TDColor.Neutral.neutral800
        $0.isSecureTextEntry = true
    }
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
        $0.backgroundColor = TDColor.Neutral.neutral50
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = TDColor.Neutral.neutral300.cgColor
    }
    let verifyPasswordTextField = UITextField().then {
        $0.placeholder = "새 비밀번호 확인"
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
    private let confirmButton = TDBaseButton(
        title: "확인",
        backgroundColor: TDColor.Primary.primary500,
        foregroundColor: TDColor.baseWhite,
        radius: 12,
        font: TDFont.boldHeader3.font
    )
    
    // MARK: Properties
    weak var coordinator: FindAccountCoordinator?
    
    // MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: Common Methods
    override func addView() {
        view.addSubview(passwordLabel)
        view.addSubview(passwordStackView)
        view.addSubview(verifypasswordStackView)
        view.addSubview(confirmButton)
        setupPasswordInputView()
        setupVerifyPasswordInputView()
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
    
    override func layout() {
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(44)
            $0.leading.equalToSuperview().offset(25)
        }
        passwordStackView.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        passwordContainerView.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        passwordTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        invaildPasswordDummyView.snp.makeConstraints { make in
            make.width.equalTo(0)
        }
        
        verifypasswordStackView.snp.makeConstraints { make in
            make.top.equalTo(passwordStackView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        verifyPasswordContainerView.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        verifyPasswordTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        invaildVerifyPasswordDummyView.snp.makeConstraints { make in
            make.width.equalTo(0)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(48)
        }
    }
    
    override func configure() {
        layoutView.backgroundColor = .white
        invaildPasswordLabel.isHidden = true
        invaildVerifyPasswordLabel.isHidden = true
        
        confirmButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.finish(by: .pop)
        }, for: .touchUpInside)
    }
}
