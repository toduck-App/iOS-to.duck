import UIKit
import Combine
import TDDomain
import TDDesign

final class ChangePasswordViewController: BaseViewController<BaseView> {
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
    private let viewModel: ChangePasswordViewModel
    private let input = PassthroughSubject<ChangePasswordViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: FindAccountCoordinator?
    
    // MARK: Initializer
    init(
        viewModel: ChangePasswordViewModel
    ) {
        self.viewModel = viewModel
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        passwordTextField.delegate = self
        verifyPasswordTextField.delegate = self
        
        confirmButton.addAction(UIAction { [weak self] _ in
            self?.input.send(.changePassword)
        }, for: .touchUpInside)
    }
    
    override func binding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .invalidPassword:
                    self?.invaildPasswordLabel.isHidden = false
                    self?.passwordContainerView.layer.borderColor = TDColor.Semantic.error.cgColor
                    self?.passwordContainerView.backgroundColor = TDColor.Semantic.error.withAlphaComponent(0.05)
                case .validPassword:
                    self?.invaildPasswordLabel.isHidden = true
                    self?.passwordContainerView.layer.borderColor = TDColor.Neutral.neutral300.cgColor
                    self?.passwordContainerView.backgroundColor = TDColor.Neutral.neutral50
                case .passwordMismatch:
                    self?.invaildVerifyPasswordLabel.isHidden = false
                    self?.verifyPasswordContainerView.layer.borderColor = TDColor.Semantic.error.cgColor
                    self?.verifyPasswordContainerView.backgroundColor = TDColor.Semantic.error.withAlphaComponent(0.05)
                case .passwordMatched:
                    self?.invaildVerifyPasswordLabel.isHidden = true
                    self?.verifyPasswordContainerView.layer.borderColor = TDColor.Neutral.neutral300.cgColor
                    self?.verifyPasswordContainerView.backgroundColor = TDColor.Neutral.neutral50
                case .updateNextButtonState(let isEnabled):
                    self?.confirmButton.isEnabled = isEnabled
                    self?.confirmButton.layer.borderWidth = 0
                case .failureAPI(let message):
                    self?.showErrorAlert(errorMessage: message)
                }
            }.store(in: &cancellables)
    }
}

// MARK: - UITextFieldDelegate
extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == passwordTextField {
            let password = passwordTextField.text ?? ""
            input.send(.validatePassword(password))
        }
        
        if textField == verifyPasswordTextField {
            let password = passwordTextField.text ?? ""
            let verifyPassword = verifyPasswordTextField.text ?? ""
            input.send(.checkPasswordMatch(password, verifyPassword))
        }
    }
}
